context("test-shim.R")

test_that("shimmed arguments match unshimmed", {
  expect_equal(formals(shim_require), formals(base::require))
  expect_equal(formals(shim_library), formals(base::library))
})

test_that("shims load package with conflicts silently", {
  red <- function() {}

  expect_message(shim_library(crayon), NA)
  detach("package:crayon")

  expect_message(shim_require(crayon, quietly = TRUE), NA)
  detach("package:crayon")
})

test_that("shimmed help returns same as unshimmed", {
  expect_equal(
    shim_library(help = "rlang"),
    base::library(help = "rlang")
  )

  expect_equal(
    shim_library(help = rlang),
    base::library(help = rlang)
  )
})

test_that("shimmed library() returns same as unshimmed", {
  expect_equal(
    shim_library(),
    base::library()
  )
})

# package_name ------------------------------------------------------------

test_that("package_name mimics library", {
  expect_equal(package_name(quo(ggplot2)), "ggplot2")

  x <- "ggplot2"
  expect_equal(package_name(quo(x), TRUE), "ggplot2")
})

test_that("package_name throws errors with invalid names" ,{
  x <- c("x", "y")
  expect_error(package_name(quo(x), TRUE), "character vector")

  x <- 1:10
  expect_error(package_name(quo(x), TRUE), "character vector")

  x <- NA_character_
  expect_error(package_name(quo(x), TRUE), "NA")

  x <- ""
  expect_error(package_name(quo(x), TRUE), "''")
})
