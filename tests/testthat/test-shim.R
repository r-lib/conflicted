context("test-shim.R")

test_that("shimmed arguments match unshimmed", {
  shims_bind()
  expect_equal(formals(require), formals(base::require))
  expect_equal(formals(library), formals(base::library))
})

test_that("shims load package with conflicts silently", {
  red <- function() {}
  shims_bind()

  expect_message(library(crayon), NA)
  detach("package:crayon")

  expect_message(require(crayon, quietly = TRUE), NA)
  detach("package:crayon")
})

test_that("detaching package removes shims", {
  skip_if_not("chr" %in% pkg_ls("crayon") && "chr" %in% pkg_ls("rlang"))
  shims_bind()

  library(crayon)
  library(rlang)
  expect_true(exists("chr", ".conflicts", inherits = FALSE))

  detach("package:crayon")
  detach("package:rlang")
  expect_false(exists("chr", ".conflicts", inherits = FALSE))
})

test_that("shimmed help returns same as unshimmed", {
  shims_bind()

  expect_equal(
    library(help = "rlang"),
    base::library(help = "rlang")
  )

  expect_equal(
    library(help = rlang),
    base::library(help = rlang)
  )
})

test_that("shimmed library() returns same as unshimmed", {
  shims_bind()

  expect_equal(library(), base::library())
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
