#' Parser for checkboxes
#'
#' Converts GPT answers yes/no to logical.
#'
#' @param x (chr) The character vector to parse.
#'
#' @return (lgl) The parsed logical vector.
#' @export
#'
#' @examples
#' parse_checkbox("si")
#' parse_checkbox("no")
#' parse_checkbox("NA")
#' parse_checkbox("N/A")
parse_checkbox <- function(x) {
  res <- stringi::stri_enc_toascii(stringr::str_to_lower(x)) == "si"
  tidyr::replace_na(res, FALSE) |> 
    as.integer()
}

#' Parser for GPT factors
#'
#' Converts GPT strings reporting categories to factors, using proper
#' levels derived from the target factor.
#'
#' @note
#' The target factor it is supposed that will be overwritten by the
#' resulting factor of this function.
#'
#' @param from_str (chr) The character vector to parse.
#' @param to_fct (fct) The target factor
#'
#' @return (fct) The parsed factor.
#' @export
#'
#' @examples
#' parse_gpt_fctr(c("si", "no", "forse"), factor(c("si", "no")))
parse_gpt_fctr <- function(from_str, to_fct) {
  .levels <- levels(to_fct)

  lover_level <- stringr::str_to_lower(.levels) |>
    stringi::stri_enc_toascii() |>
    stringr::str_remove_all("[^a-zA-Z]") |>
    stringr::str_squish()

  res_str <- from_str |>
    dplyr::na_if("NA") |>
    stringr::str_to_lower() |>
    stringi::stri_enc_toascii() |>
    stringr::str_remove_all("[^a-zA-Z]") |>
    stringr::str_squish() |>
    purrr::map_chr(\(x) {
      res <- stringr::str_which(lover_level, stringr::fixed(x))
      if (length(res) != 1) NA_character_ else .levels[res]
    })

  if (!all(res_str %in% c(.levels, NA_character_))) {
    usethis::ui_warn("Not all strings parsed correctly.")
    usethis::ui_info(
      "Unique strings where {stringr::str_c(unique(res_str), collapse = ', ')}"
    )
  }

  forcats::fct(res_str, .levels) |> 
    forcats::fct_na_value_to_level("Non rilevato")
}
