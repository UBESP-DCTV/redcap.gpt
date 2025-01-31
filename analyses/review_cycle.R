library(tidyverse)
library(here)
library(rio)
options(rio.import.class = "tibble")



# Supporting funcitons --------------------------------------------

merge_review <- function(reviews_raw, type = c("comments", "details", "note")) {
  type <- match.arg(type)
  type <- paste0("^", type)

  reviews_raw <- reviews_raw |>
    map(\(x) {
      if ("0+E:AA5_comments_fup_text_feeling___1" %in% names(x)) {
        x |>
          dplyr::rename(
            "05_comments_fup_text_feeling___1" = "0+E:AA5_comments_fup_text_feeling___1"
          )
      } else {
        x
      }
    })

  reviews_raw[stringr::str_detect(names(reviews_raw), type)] |>
    purrr::list_rbind(names_to = "reviewer") |>
    dplyr::mutate(
      reviewer = stringr::str_extract(reviewer, "(?<=rev)\\d$")
    )
}


# data ------------------------------------------------------------

ciclo <- "ciclo_01"

reviews_raw <- here(str_glue("data-raw/{ciclo}")) |>
  list.files(full.names = TRUE) |>
  import_list()

comments <- reviews_raw |>
  merge_review("comments")

details <- reviews_raw |>
  merge_review("details")

notes <- reviews_raw |>
  merge_review("note")


# Analysis --------------------------------------------------------
comments |>
  select(-c(
    "29_comments_fup_text_processed_record___1"
  )) |>
  pivot_wider(
    id_cols = c(
      "01_record_id", "02_redcap_repeat_instrument",
      "03_redcap_repeat_instance", "04_comments_fup",
      ends_with("_motivation"), matches("___\\d$")
    ),
    names_from = "reviewer",
    values_from = ends_with("_check")
  ) |>
  View()
export("output/comments_merged.xlsx")

details |>
  pivot_wider(
    id_cols = c(
      "01_record_id", "02_redcap_repeat_instrument",
      "03_redcap_repeat_instance", "04_details_fup",
      ends_with("_motivation"), matches("___\\d$")
    ),
    names_from = "reviewer",
    values_from = ends_with("_check")
  ) |>
  export("output/details_merged.xlsx")

notes |>
  pivot_wider(
    id_cols = c(
      "01_record_id", "02_redcap_repeat_instrument",
      "03_redcap_repeat_instance", "04_note_fup",
      ends_with("_motivation"), matches("___\\d$")
    ),
    names_from = "reviewer",
    values_from = ends_with("_check")
  ) |>
  export("output/notes_merged.xlsx")
