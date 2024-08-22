add_check_to_varnames <- function(db) {
  db |>
    dplyr::rename_with(
      \(x) seq_along(db) |>
        stringr::str_pad(2, pad = "0") |>
        stringr::str_c("_", x)
    ) |>
    dplyr::mutate(
      dplyr::across(
        .cols = c(
          dplyr::contains("_fup_text_"),
          -dplyr::matches("motivation|processed")
        ),
        .fns = \(x) NA,
        .names = "{.col}_check"
      )
    ) |>
    (\(x) x |>
      dplyr::relocate(
        dplyr::all_of(sort(names(x)))
      )
    )()
}
