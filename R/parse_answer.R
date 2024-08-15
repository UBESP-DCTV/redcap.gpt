parse_sensazione <- function(x) {
  stringi::stri_enc_toascii(stringr::str_to_lower(x)) == "si"
}

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
  
  if (!all(res_str %in% .levels)) {
    usethis::ui_warn("Not all stringrs parsed correctly.")
    usethis::ui_info(
      "Unique strings where {stringr::str_c(unique(res_str), collapse = ', ')}"
    )
  }

  forcats::fct(res_str, .levels)
}
