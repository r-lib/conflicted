test_that("pkg_ls() respects exclude", {
  skip_if_not(getRversion() >= "3.6")

  library(callr)
  expect_true("r" %in% pkg_ls("callr"))
  pkgload::unload("callr")

  library(callr, exclude = "r")
  expect_false("r" %in% pkg_ls("callr"))
  pkgload::unload("callr")
})
