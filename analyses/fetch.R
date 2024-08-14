library(REDCapTidieR)
library(redcap.gpt)
library(dplyr)
library(purrr)


db <- REDCapTidieR::read_redcap(get_redcap_uri(), get_redcap_token())
db

fetch_form("followup_postoperatorio_14_30_60_giorno_po")

selected <- db |> 
  filter(
    redcap_form_name %in% c(
      "followup_postoperatorio_14_30_60_giorno_po",
      "visita_followup_postoperatorio_90_giorno_po"
    )
  ) |> 
  extract_tibbles(c(
    followup_postoperatorio_14_30_60_giorno_po,
    visita_followup_postoperatorio_90_giorno_po
  )) |>
  map(\(x) {
    x |> 
      select(
        all_of(c("record_id", "redcap_form_instance")),
        matches("note|comments_fup|details|complete")
      )
  })


glimpse(selected)
selected[[1]][[12]]
