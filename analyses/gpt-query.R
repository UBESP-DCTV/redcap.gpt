library(tidyverse)
library(redcap.gpt)
library(gpteasyr)
library(janitor)
library(stringi)

form <- "followup_postoperatorio_14_30_60_giorno_po"


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

res_extended <- res |> 
  mutate(
    gpt_parsed = map(gpt_res, \(x) {
      x |>
        gpt_to_tibble() |> 
        mutate(
          across(
            matches("sensazione_.*_risposta"),
            parse_sensazione
          )
        )      
    })
  ) |> 
  unnest(cols = gpt_parsed)


res_extended$momento_risposta
