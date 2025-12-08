#' Connect to an Azure Blob Storage Container
#' @param app_id Azure Active Directory application (client) ID. Defaults to the
#'   `AZ_APP_ID` environment variable. If empty, authentication will rely on
#'   Managed Identity (see [get_az_token]).
#' @param ep_uri Azure Blob Storage endpoint URI. Defaults to the
#'   `AZ_STORAGE_EP` environment variable. Should follow the format:
#'   `"https://<storage-account>.blob.core.windows.net/"`.
#' @param container_name The name of the blob container to connect to.
#' @return An AzureStor container object created by
#'   `AzureStor::storage_container()`.
connect_az_container <- function(
  app_id = Sys.getenv("AZ_APP_ID"),
  ep_uri = Sys.getenv("AZ_STORAGE_EP"),
  container_name
) {
  token <- get_az_token(app_id)
  ep_uri |>
    AzureStor::blob_endpoint(token = token) |>
    AzureStor::storage_container(container_name)
}

#' Read an Azure Table Storage Table into a Tibble
#' @param app_id Azure Active Directory application (client) ID. Defaults to
#'   `AZ_APP_ID`. If empty, Managed Identity authentication will be used (via
#'   [get_az_token]).
#' @param ep_uri The Azure Table Storage endpoint URI. Defaults to `AZ_TABLE_EP`
#'   and should include a trailing slash, e.g.:
#'   `"https://<storage-account>.table.core.windows.net/"`.
#' @param table_name The name of the Azure Table to query. Defaults to
#'   `AZ_TABLE_NAME`.
#' @return A tibble containing all table entities. Each entity is converted from
#'   JSON into a tibble and row-bound into a single data frame.
read_az_table <- function(
  app_id = Sys.getenv("AZ_APP_ID"),
  ep_uri = Sys.getenv("AZ_TABLE_EP"),
  table_name = Sys.getenv("AZ_TABLE_NAME")
) {
  token <- get_az_token(app_id)

  req <- httr2::request(glue::glue("{ep_uri}{table_name}")) |>
    httr2::req_auth_bearer_token(token$credentials$access_token) |>
    httr2::req_headers(
      `x-ms-version` = "2023-11-03",
      Accept = "application/json;odata=nometadata"
    )
  resp <- httr2::req_perform(req)
  entities <- httr2::resp_body_json(resp)

  entities[[1]] |> # response is contained in a list
    purrr::map(tibble::as_tibble) |>
    purrr::list_rbind()
}

#' Acquire an Azure Active Directory Token for Storage Authentication
#' @param app_id Azure Active Directory application (client) ID. Used when
#'   running the function locally. If empty (e.g. when deployed), the
#'   function uses Managed Identity authentication.
#' @return An AzureAuth token object (OAuth or Managed Identity), suitable for
#'   authenticating against Azure Storage services.
get_az_token <- function(app_id) {
  if (app_id != "") {
    AzureAuth::get_azure_token(
      resource = "https://storage.azure.com",
      tenant = "common",
      app = app_id,
      auth_type = "authorization_code",
      use_cache = TRUE # avoid browser-authorisation prompt
    )
  } else {
    AzureAuth::get_managed_token("https://storage.azure.com/")
  }
}

#' Prepare and Standardize Azure Table Storage Metadata
#' @param az_table A tibble of entities returned from Azure Table Storage,
#'   typically produced by [read_az_table]. Must contain at least the
#'   columns `PartitionKey`, `scenario`, `create_datetime`, `run_stage`,
#'   `results_dir`, and `results_file`.
#' @return A tibble containing the columns:
#'   - `dataset` (scheme code)
#'   - `scenario` (scenario name)
#'   - `create_datetime` (needed because `scenario` isn't unique)
#'   - `run_stage` ('final_report_ndg2', etc)
#'   - `file` (path to the `params.json` file, or `.json.gz` containing params)
prepare_az_table <- function(az_table) {
  az_table |>
    dplyr::mutate(
      file = dplyr::if_else(
        is.na(results_dir),
        results_file,
        fs::path(results_dir, "params.json") |> as.character()
      )
    ) |>
    dplyr::select(
      dataset = PartitionKey,
      scenario,
      create_datetime,
      run_stage,
      file
    )
}
