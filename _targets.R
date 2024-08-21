library(targets)
library(tarchetypes)

tar_option_set(
  packages = c("REDCapR"),
  format = "qs",
  error = "continue",
  controller = crew::crew_controller_local(
    workers = 2,
    seconds_idle = 60
  ),
  seed = 1234
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()

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
      query_gpt_on_redcap_instrument("note_fup")
  ),
  tar_target(
    name = comments_fup_to_be_pushed,
    command = fup_143060 |> 
      query_gpt_on_redcap_instrument("comments_fup")
  ),
  tar_target(
    name = details_fup_to_be_pushed,
    command = fup_90 |> 
      query_gpt_on_redcap_instrument("details_fup")
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
    skip = nrow(validate_for_write(note_fup_to_be_pushed)) != 0
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
    skip = nrow(validate_for_write(comments_fup_to_be_pushed)) != 0
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
    skip = nrow(validate_for_write(details_fup_to_be_pushed)) != 0
  )
)
