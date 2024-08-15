#' GPT JSON to tibble
#'
#' @param gpt_json (chr) The GPT JSON.
#'
#' @return (tbl_df) The GPT tibble.
#' @export
gpt_to_tibble <- function(gpt_json) {
  gpt_json |>
    stringr::str_remove_all("```(json)?") |>
    stringr::str_squish() |>
    jsonlite::fromJSON() |>
    purrr::list_flatten() |>
    dplyr::bind_cols()
}
