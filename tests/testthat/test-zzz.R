context("test-zzz.R")

test_that("detaching removes shims", {
  skip_if(pkg_devtools("conflicted"))

  # I honestly don't understand why this works - detaching the package
  # being tested seems like a bad bad idea; maybe it's ok because it's the
  # last test?
  detach(package:conflicted)
  testthat::expect_false("conflicted" %in% search())
})
