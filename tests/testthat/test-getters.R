test_that("getters works", {
  withr::local_envvar(
    REDCAP_URI = "https://example.com",
    REDCAP_PID=1,
    REDCAP_TOKEN="supersecret!"
  )

  expect_equal(get_redcap_uri(), "https://example.com")
  expect_equal(get_redcap_pid(), 1L)
  expect_equal(
    expect_invisible(get_redcap_token()),
    "supersecret!"
  )
})
