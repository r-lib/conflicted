context("test-zzz.R")

test_that("detaching removes shims", {
  # I honestly don't understand why this works - detaching the package
  # being tested seems like a bad bad idea; maybe it's ok because it's the
  # last test?
  testthat::expect_true(conflicts_attached())
  detach(package:conflicted)
  testthat::expect_false(".conflicts" %in% search())
})
