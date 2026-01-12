#' Prepare and Standardize Azure Table Storage Metadata
#' @param az_table A tibble of entities returned from Azure Table Storage,
#'   typically produced by [azkit::read_azure_table()]. Must contain at least
#'   the columns `PartitionKey`, `scenario`, `create_datetime`, `run_stage`,
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
