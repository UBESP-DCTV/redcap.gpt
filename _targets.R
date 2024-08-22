library(targets)
library(tarchetypes)

tar_option_set(
  # required packages for the pipeline
  packages = c("purrr", "REDCapR"),
  # fast data formats
  format = "qs",
  # error handling
  error = "continue",
  workspace_on_error = TRUE,
  # parallel processing
  storage = "worker",
  retrieval = "worker",
  controller = crew::crew_controller_local(
    workers = 3,
    seconds_idle = 60
  ),
  # reproducibility
  seed = 1234
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()

params <- list(
  query_on_all_records = TRUE,
  write_on_redcap = FALSE
)

list(
  tar_target(
    name = fup_143060,
    command = fetch_form("followup_postoperatorio_14_30_60_giorno_po")
  ),
  tar_target(
    name = fup_90,
    command = fetch_form("visita_followup_postoperatorio_90_giorno_po")
  ),
  tar_target(
    name = note_fup_to_be_pushed,
    command = fup_143060 |> 
      query_gpt_on_redcap_instrument(
        "note_fup",
        query_on_all_records = params[["query_on_all_records"]]
      )
  ),
  tar_target(
    name = comments_fup_to_be_pushed,
    command = fup_143060 |> 
      query_gpt_on_redcap_instrument(
        "comments_fup",
        query_on_all_records = params[["query_on_all_records"]]
      )
  ),
  tar_target(
    name = details_fup_to_be_pushed,
    command = fup_90 |> 
      query_gpt_on_redcap_instrument(
        "details_fup",
        query_on_all_records = params[["query_on_all_records"]]
      )
  ),
  tar_skip(
    name = write_note_fup,
    command = note_fup_to_be_pushed  |> 
      redcap_write(
        ds_to_write = _,
        redcap_uri  = get_redcap_uri(),
        token       = get_redcap_token(),
        convert_logical_to_integer = TRUE
      ),
    skip = !params[["write_on_redcap"]] ||
      (nrow(validate_for_write(note_fup_to_be_pushed)) != 0)
  ),
  tar_skip(
    name = write_comments_fup,
    command = comments_fup_to_be_pushed  |> 
      redcap_write(
        ds_to_write = _,
        redcap_uri  = get_redcap_uri(),
        token       = get_redcap_token(),
        convert_logical_to_integer = TRUE
      ),
    skip =  !params[["write_on_redcap"]] ||
      (nrow(validate_for_write(comments_fup_to_be_pushed)) != 0)
  ),
  tar_skip(
    name = write_details_fup,
    command = details_fup_to_be_pushed  |> 
      redcap_write(
        ds_to_write = _,
        redcap_uri  = get_redcap_uri(),
        token       = get_redcap_token(),
        convert_logical_to_integer = TRUE
      ),
    skip =  !params[["write_on_redcap"]] ||
      (nrow(validate_for_write(details_fup_to_be_pushed)) != 0)
  ),
  tar_target(
    dbToCheck,
    list(
      note_fup = note_fup_to_be_pushed,
      comments_fup = comments_fup_to_be_pushed,
      details_fup = details_fup_to_be_pushed
    ) |>
      discard(is.null) |>
      map(add_check_to_varnames) |>
      (\(x) x |> set_names(paste0(names(x), "_to_check")))()
  ),
  tar_target(
    shareDbToCheck,
    share_objects(dbToCheck),
    format = "file"
  )
)
