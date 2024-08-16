test_that("parse_sensazione works", {
  # evaluate
  res <- parse_sensazione(c("si", "no", "forse", NA))

  # test
  expect_equal(res, c(TRUE, FALSE, FALSE, FALSE))
})
