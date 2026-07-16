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
    dplyr::filter(!is.na(run_stage)) |> # must have a run-stage label
    dplyr::mutate(
      .keep = "none",
      dataset,
      scenario,
      create_datetime = create_datetime |>
        lubridate::ymd_hms() |>
        format("%Y%m%d_%H%M%S"),
      run_stage,
      file = dplyr::if_else(
        is.na(aggregated_results_path),
        results_json_gz_path,
        fs::path(aggregated_results_path, "params.json") |> as.character()
      )
    ) |>
    dplyr::relocate("create_datetime", .after = "scenario") |>
    dplyr::arrange(.data$dataset, dplyr::desc(.data$create_datetime))
}
