test_that("fetch_redcap works", {
  # setup
  skip_on_ci()
  skip_on_cran()

  # evaluation
  full <- fetch_redcap()

  # expectation
  expect_tibble(full, ncols = 10, nrows = 12)
})

test_that("fetch_form works", {
  # setup
  skip_on_ci()
  skip_on_cran()

  # evaluation
  fup <- fetch_form("followup_postoperatorio_14_30_60_giorno_po")
  fup_fup <- fetch_redcap() |>
    dplyr::filter(
      redcap_form_name == "followup_postoperatorio_14_30_60_giorno_po",
    ) |>
    dplyr::pull(redcap_data) |>
    purrr::pluck(1)

  # expectation
  expect_equal(fup, fup_fup)
})
