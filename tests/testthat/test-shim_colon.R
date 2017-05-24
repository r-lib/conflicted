context("shim_colon")

test_that("regular calls work", {
  expect_equal(shim_colon(1, 10), 1:10)
  expect_equal(shim_colon(-1, 10), (-1):10)
  expect_equal(shim_colon(-10, 0), (-10):0)
})

test_that("positive from and 0 to causes error", {
  expect_error(shim_colon(1, 0), "descending sequence")
})
