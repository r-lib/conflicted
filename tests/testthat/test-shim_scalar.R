context("shim_scalar")

test_that("throw errors for scalar x", {
  expect_error(strict_diag(5), "surprising")
  expect_error(strict_sample(5), "surprising")
})
