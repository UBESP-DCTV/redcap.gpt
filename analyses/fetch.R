library(REDCapTidieR)
library(redcap.gpt)
library(dplyr)
library(purrr)


db <- REDCapTidieR::read_redcap(get_redcap_uri(), get_redcap_token())
db

db |> 
  filter(
    redcap_form_name %in% c(
      "followup_postoperatorio_14_30_60_giorno_po",
      "visita_followup_postoperatorio_90_giorno_po"
    )
  ) |> 
  mutate(
    redcap_data = redcap_data |> 
      map(\(x) {
        x |> 
          select(
            all_of(c("record_id", "redcap_form_instance")),
            matches("note|comments_fup|details|complete")
          )
      }) |> 
      set_names(redcap_form_name)
  ) |> 
  pull(redcap_data)
