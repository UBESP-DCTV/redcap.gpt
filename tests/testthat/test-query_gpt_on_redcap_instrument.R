test_that("query_gpt_on_redcap works", {
  # setup
  skip_on_ci()
  skip_on_cran()
    
  fup_143060 <- fetch_form("followup_postoperatorio_14_30_60_giorno_po")
  fup_90 <- fetch_form("visita_followup_postoperatorio_90_giorno_po")

  # evaluation
  note_fup <- fup_143060 |> 
    query_gpt_on_redcap_instrument("note_fup")

  comments_fup <- fup_143060 |> 
    query_gpt_on_redcap_instrument("comments_fup")

  details_fup <- fup_90 |> 
    query_gpt_on_redcap_instrument("details_fup")

  # tests
  expect_tibble(note_fup, max.rows = nrow(fup_143060), ncols = 24)
  expect_true(all(note_fup[["note_fup_text_processed_record___1"]]))

  expect_tibble(comments_fup, max.rows = nrow(fup_143060), ncols = 24)
  expect_true(all(note_fup[["comments_fup_text_processed_record___1"]]))

  expect_tibble(details_fup, max.rows = nrow(fup_90), ncols = 24)
  expect_true(all(note_fup[["details_fup_text_processed_record___1"]]))

})
