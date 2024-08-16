test_that("parse_sensazione works", {
  # evaluate
  res <- parse_sensazione(c("si", "no", "forse", NA))

  # test
  expect_equal(res, c(1, 0, 0, 0))
})

test_that("parse_gpt_fctr works on missing", {
  # setup
  s1 <- c("a", "b", NA)
  f1 <- factor(s1)

  # evaluate
  res <- parse_gpt_fctr(s1, f1)

  # test
  expect_factor(res, c("a", "b", "Non rilevato"))
})