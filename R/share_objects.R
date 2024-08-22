share_objects <- function(obj_list, excel = TRUE) {
  now <- lubridate::now() |>
    stringr::str_remove_all("\\W+") |>
    stringr::str_sub(1, 12)

  file_name_now <- stringr::str_c(
    names(obj_list), "-", now, ".rds"
  )

  file_name_latest <- stringr::str_c(
    names(obj_list), "-", "latest", ".rds"
  )

  obj_paths_now <- file.path("output", file_name_now) |>
    normalizePath(mustWork = FALSE) |>
    purrr::set_names(names(obj_list))

  obj_paths_latest <- file.path("output", file_name_latest) |>
    normalizePath(mustWork = FALSE) |>
    purrr::set_names(names(obj_list))

  if (excel) {
    obj_list_excel <- obj_list |>
      purrr::map(
        \(db) db |>
          dplyr::mutate(
            dplyr::across(
              dplyr::where(is.character),
              \(col) stringr::str_trunc(col, 32767)
            )
          )
      )
    obj_list_excel |>
      rio::export_list(file.path("output", "%s-latest.xlsx"))

    obj_list_excel |>
      rio::export_list(
        file.path("output", stringr::str_c("%s-", now, ".xlsx"))
      )
  }

  # Those must be RDS
  obj_list |>
    purrr::walk2(obj_paths_now, readr::write_rds)
  obj_list |>
    purrr::walk2(obj_paths_latest, readr::write_rds)

  obj_paths_latest
}
