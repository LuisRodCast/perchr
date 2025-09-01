test_that("Token storage works", {
  perch_auth("dummy_token")
  expect_equal(getOption("perchr.token"), "dummy_token")
})
