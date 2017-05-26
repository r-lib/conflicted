context("shim_risky")

test_that("strict_drop detects when default ok", {
  expect_equal(strict_drop(c(TRUE, TRUE)), FALSE)
  expect_equal(strict_drop(1:5), FALSE)
  expect_equal(strict_drop(letters[1:2]), FALSE)
  expect_equal(strict_drop(), FALSE)
})

test_that("strict_drop errors instead of returning TRUE", {
  expect_error(strict_drop(c(TRUE)), "`drop`")
  expect_error(strict_drop(1), "`drop`")
  expect_error(strict_drop("a"), "`drop`")
})
