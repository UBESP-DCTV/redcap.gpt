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
  note_fup |> 
    expect_tibble(
      max.rows = nrow(fup_143060),
      ncols = 23
    )
  expect_true(
    all(note_fup[["note_fup_text_processed_record___1"]] == 1L)
  )
  note_fup |> 
    dplyr::select(dplyr::where(is.logical)) |> 
    is.na() |> 
    any() |> 
    expect_false()
  note_fup |> 
    purrr::map_lgl(\(x) is.factor(x) | is.logical(x)) |> 
    any() |> 
    expect_false()


  comments_fup |> 
    expect_tibble(
      max.rows = nrow(fup_143060),
      ncols = 23
  )
  expect_true(
    all(comments_fup[["comments_fup_text_processed_record___1"]] == 1L)
  )
  comments_fup |> 
    dplyr::select(dplyr::where(is.logical)) |> 
    is.na() |> 
    any() |> 
    expect_false()
  comments_fup |> 
    purrr::map_lgl(\(x) is.factor(x) | is.logical(x)) |> 
    any() |> 
    expect_false()

  details_fup |> 
    expect_tibble(
      max.rows = nrow(fup_90),
      ncols = 23
    )
  expect_true(
    all(comments_fup[["details_fup_text_processed_record___1"]] == 1L)
  )
  details_fup |> 
    dplyr::select(dplyr::where(is.logical)) |> 
    is.na() |> 
    any() |> 
    expect_false()
  details_fup |> 
    purrr::map_lgl(is.factor) |> 
    any() |> 
    expect_false()

})

test_that("structural colnames are correct", {
  # setup
  skip_on_ci()
  skip_on_cran()
    
  fup_143060 <- fetch_form("followup_postoperatorio_14_30_60_giorno_po")

  # evaluation
  note_fup <- fup_143060 |> 
    query_gpt_on_redcap_instrument("note_fup")

  # test
  expect_subset(
    c("redcap_repeat_instrument", "redcap_repeat_instance"),
    names(note_fup)
  )
})