context("test-find")


# deprecated functions ----------------------------------------------------

test_that("can call to .Deprecated", {
  f <- function() {
    .Deprecated('x')
  }

  expect_true(is_deprecated(f))
})

test_that("returns FALSE for weird inputs", {
  expect_false(is_deprecated(20))
  expect_false(is_deprecated(mean))

  f <- function() {}
  expect_false(is_deprecated(f))
})
