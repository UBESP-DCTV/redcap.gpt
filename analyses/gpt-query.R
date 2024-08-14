library(redcap.gpt)
library(gpteasyr)
library(dplyr)
library(janitor)
library(stringr)
library(jsonlite)

form <- "followup_postoperatorio_14_30_60_giorno_po"

fetch_form(form) |> 
  filter(row_number() == 2)

fetch_form(form) |> 
  filter(row_number() == 2) |> 
  remove_empty("cols") |> 
  glimpse()

sys <- compose_sys_prompt(
  role = compose_sys_role(),
  context = compose_sys_context()
)
usr <- compose_usr_prompt(
  task = compose_usr_task(),
  instructions = compose_usr_instructions(),
  output = compose_usr_output(),
  style = compose_usr_style(),
  examples = compose_usr_example(),
  closing = compose_usr_closing(),
  delimiter = "#####"
)

res <- fetch_form(form) |> 
  dplyr::select(
    record_id, redcap_form_instance, 
    starts_with("note_fup")
  ) |> 
  filter(!is.na(note_fup)) |> 
  query_gpt_on_column(
    "note_fup",
     sys, usr,
     closing = "Procedi passo-passo per assicurarti di restituire la migliore risposta corretta possibile.",
     seed = 1234
  )

res[["gpt_res"]][[1]] |> 
  str_remove_all("```(json)?") |> 
  str_squish() |> 
  jsonlite::fromJSON() |> 
  purrr::list_flatten() |> 
  bind_cols() |> 
  mutate(
    across(
      matches("sensazione_.*_risposta"),
      \(x) stringi::stri_enc_toascii(str_to_lower(x)) == "si"
    )
  )
