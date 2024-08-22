#!/usr/bin/env r

library(redcap.gpt)
library(REDCapR)
library(usethis)

ui_todo("Fetching REDCap data...")
fup_143060 <- fetch_form("followup_postoperatorio_14_30_60_giorno_po")
ui_done("form 14/30/60 fup fetched")
fup_90 <- fetch_form("visita_followup_postoperatorio_90_giorno_po")
ui_done("form 90 fup fetched")
ui_done("Fetching completed.")


ui_todo("Querying GPT...")
note_fup_to_be_pushed <- fup_143060 |> 
  query_gpt_on_redcap_instrument("note_fup")
n_note_fup <- nrow(note_fup_to_be_pushed)
ui_info("{n_note_fup} records to process for note_fup on form 14/30/60 fup.")
ui_done("note_fup on form 14/30/60 fup queried and processed.")  

comments_fup_to_be_pushed <- fup_143060 |> 
  query_gpt_on_redcap_instrument("comments_fup")
n_comments_fup <- nrow(comments_fup_to_be_pushed)
ui_info("{n_comments_fup} records to process for comments_fup on form 14/30/60 fup.")
ui_done("comments_fup on form 14/30/60 fup queried and processed.")  

details_fup_to_be_pushed <- fup_90 |> 
  query_gpt_on_redcap_instrument("details_fup")
n_details_fup <- nrow(details_fup_to_be_pushed)
ui_info("{n_details_fup} records to process for details_fup on form 90 fup.")
ui_done("details_fup on form 90 fup queried and processed.")  

n_to_write <- n_note_fup + n_comments_fup + n_details_fup
ui_info("{n_to_write} records to process overall.")
ui_done("Queries completed.")


ui_todo("Updating REDCap DB...")
completed <- 0L
go_note_fup <- nrow(note_fup_to_be_pushed) != 0
if (!go_note_fup) {
  ui_info("No more records to process for note_fup on 14/30/60 fup.")
} else {
  if (go_note_fup && nrow(validate_for_write(note_fup_to_be_pushed)) == 0) {
    res_note_fup <- note_fup_to_be_pushed  |> 
      REDCapR::redcap_write(
        ds_to_write = _,
        redcap_uri  = get_redcap_uri(),
        token       = get_redcap_token(),
        convert_logical_to_integer = TRUE
      )
    ui_info("{res_note_fup[['records_affected_count']]} records affected.")
    if (res_note_fup[["success"]]) {
      ui_done("note_fup on form 14/30/60 fup written on REDCap.")
      completed[] <- completed[[1L]] + 1L  
    } else {
      ui_warn("Writing process failed for note_fup on 14/30/60 fup.")
    }
  } else {
    ui_warn("note_fup on form 14/30/60 fup has issues and it is NOT written on REDCap.")
    print(validate_for_write(note_fup_to_be_pushed))
  }
}

go_comments_fup <- nrow(comments_fup_to_be_pushed) != 0
if (!go_comments_fup) {
  ui_info("No more records to process for comments_fup on 14/30/60 fup.")
} else {
  if (nrow(validate_for_write(comments_fup_to_be_pushed)) == 0) {
    res_comments_fup <- comments_fup_to_be_pushed  |> 
      REDCapR::redcap_write(
        ds_to_write = _,
        redcap_uri  = get_redcap_uri(),
        token       = get_redcap_token(),
        convert_logical_to_integer = TRUE
      )
      ui_info("{res_comments_fup[['records_affected_count']]} records affected.")
      if (res_comments_fup[["success"]]) {
        ui_done("comments_fup on form 14/30/60 fup written on REDCap.")
        completed[] <- completed[[1L]] + 1L  
      } else {
        ui_warn("Writing process failed for comments_fup on 14/30/60 fup.")
      }
    } else {
    ui_warn("comments_fup on form 14/30/60 fup has issues and it is NOT written on REDCap.")
    print(validate_for_write(comments_fup_to_be_pushed))
  }
}

go_details_fup <- nrow(details_fup_to_be_pushed) != 0
if (!go_details_fup) {
  ui_info("No more records to process for details_fup on 90 fup.")
} else {
  if (nrow(validate_for_write(details_fup_to_be_pushed)) == 0) {
    res_details_fup <- details_fup_to_be_pushed  |> 
      REDCapR::redcap_write(
        ds_to_write = _,
        redcap_uri  = get_redcap_uri(),
        token       = get_redcap_token(),
        convert_logical_to_integer = TRUE
      )
      ui_info("{res_details_fup[['records_affected_count']]} records affected.")
      if (res_details_fup[["success"]]) {
        ui_done("details_fup on form 90 fup written on REDCap.")
        completed[] <- completed[[1L]] + 1L  
      } else {
        ui_warn("Writing process failed for details_fup on 90 fup.")
      }
  } else {
    ui_warn("details_fup on form 90 fup has issues and it is NOT written on REDCap.")
    print(validate_for_write(details_fup_to_be_pushed))
  }
}

ui_done("{completed} instruments out of three were updated on REDCap DB.")
