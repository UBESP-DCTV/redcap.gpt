library(redcap.gpt)
library(REDCapR)

fup_143060 <- fetch_form("followup_postoperatorio_14_30_60_giorno_po")
# fup_90 <- fetch_form("visita_followup_postoperatorio_90_giorno_po")

note_fup_to_be_pushed <- fup_143060 |> 
  query_gpt_on_redcap_instrument("note_fup")

# - no missing values on logical
REDCapR::validate_for_write(note_fup_to_be_pushed)

note_fup_to_be_pushed |> 
  dplyr::glimpse()
