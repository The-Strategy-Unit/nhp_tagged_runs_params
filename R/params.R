#' Get Parameters for All Runs
#' @param runs_meta A data frame containing metadata about runs. Must include
#'   at least a `file` column with blob paths and a `dataset` column used to
#'   name the returned list elements.
#' @param container_results An AzureStor blob container object pointing to the
#'   location of the results files.
#' @return A named list of parameter objects, one per run. Names come from the
#'   `dataset` column of `runs_meta`.
get_all_params <- function(runs_meta, container_results) {
  runs_meta |>
    dplyr::pull(file) |>
    purrr::map(\(path) get_params_for_a_file(container_results, path)) |>
    purrr::set_names(runs_meta[["dataset"]])
}

#' Get Parameters for a Single File
#' @param container_results An AzureStor blob container object.
#' @param path The blob path to the JSON or gzipped JSON file.
#' @return A list containing model parameters parsed from the file.
get_params_for_a_file <- function(container_results, path) {
  is_zipped <- is_zipped_json(path)
  if (is_zipped) {
    extract_params_from_zip(container_results, path)
  } else {
    read_params_from_json(container_results, path)
  }
}

#' Check Whether Path is for a Zipped JSON
#' @param path A character string representing a blob path.
#' @return `TRUE` if the path ends with `"json.gz"`, otherwise `FALSE`.
is_zipped_json <- function(path) {
  stringr::str_detect(path, "json.gz$")
}

#' Extract Parameters from Zipped JSON in Blob Storage
#' @param container_results An AzureStor blob container object.
#' @param path Blob path to the gzipped JSON file.
#' @return A list containing the `"params"` component extracted from the JSON.
extract_params_from_zip <- function(container_results, path) {
  temp_file <- withr::local_tempfile()
  AzureStor::download_blob(container_results, path, temp_file)
  temp_file |>
    readBin(raw(), n = file.size(temp_file)) |>
    jsonlite::parse_gzjson_raw(simplifyVector = FALSE) |>
    purrr::pluck("params")
}

#' Read Parameters from a JSON File in Blob Storage
#' @param container_results An AzureStor blob container object.
#' @param path Blob path to the JSON file.
#' @return A list representing the parsed JSON contents.
read_params_from_json <- function(container_results, path) {
  json_raw <- AzureStor::storage_download(container_results, path, dest = NULL)
  json_txt <- rawToChar(json_raw)
  jsonlite::fromJSON(json_txt, simplifyVector = FALSE)
}
