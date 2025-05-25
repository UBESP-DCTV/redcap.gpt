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

  reviews_raw[stringr::str_detect(names(reviews_raw), type)][[1]]
}


get_errors <- function(gold_single, target_raw) {
  gold_single |>
    select(-ends_with("_rev1"), -ends_with("_rev2")) |>
    (\(x) set_names(x, str_remove(names(x), "^\\d+_")))() |>
    left_join(
      tar_read_raw(target_raw) |>
        select(
          # -ends_with("motivation"),
          -contains("processed_record")
        )
    ) |>
    mutate(across(everything(), as.character)) |>
    pivot_longer(
      cols = -c(
        record_id, redcap_repeat_instrument, redcap_repeat_instance,
        ends_with("_fup")
      ),
      names_to = "var",
      values_to = "value"
    ) |>
    separate(
      var,
      into = c("var", "type"),
      sep = "_((?=GOLD_STANDARD)|(?=motivation))"
    ) |>
    mutate(
      var = var |> str_replace_all("_+", "_"),
      type = if_else(is.na(type), "original", type)
    ) |>
    pivot_wider(names_from = type, values_from = value) |>
    rename(gold = GOLD_STANDARD) |>
    mutate(error = original != gold) |>
    filter(error) |>
    select(-error) |>
    rename(
      text = any_of(c("comments_fup", "details_fup", "note_fup"))
    )
}


# data ------------------------------------------------------------
dir_last_cycle <- here("data-raw") |>
  fs::dir_ls() |>
  max()

last_cycle_name <- basename(dir_last_cycle) |>
  stringr::str_remove("^\\d+-")

reviews_raw <- list.files(dir_last_cycle, full.names = TRUE) |>
  import_list()

comments <- reviews_raw |>
  merge_review("comments") |>
  filter(!is.na(`04_comments_fup`))

details <- reviews_raw |>
  merge_review("details") |>
  filter(!is.na(`04_details_fup`))

notes <- reviews_raw |>
  merge_review("note") |>
  filter(!is.na(`04_note_fup`))


# Analysis --------------------------------------------------------
list(
  comments = get_errors(comments, "comments_fup_to_be_pushed"),
  details = get_errors(details, "details_fup_to_be_pushed"),
  notes = get_errors(notes, "note_fup_to_be_pushed")
) |>
  bind_rows(.id = "type") |>
  rio::export(here("output", str_glue("{last_cycle_name}_errors.xlsx")))
