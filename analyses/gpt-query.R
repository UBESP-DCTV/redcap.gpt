library(tidyverse)
library(redcap.gpt)
library(gpteasyr)
library(janitor)
library(stringi)

full <- fetch_redcap()
fup_143060 <- fetch_form("followup_postoperatorio_14_30_60_giorno_po")
fup_90 <- fetch_form("visita_followup_postoperatorio_90_giorno_po")

note_fup_to_be_pushed <- fup_143060 |> 
  query_gpt_on_redcap_instrument("note_fup")

comments_fup_to_be_pushed <- fup_143060 |> 
  query_gpt_on_redcap_instrument("comments_fup")

details_fup_to_be_pushed <- fup_90 |> 
  query_gpt_on_redcap_instrument("details_fup")
