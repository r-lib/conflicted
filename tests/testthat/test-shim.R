test_that("shimmed arguments match unshimmed", {
  shims_bind()
  expect_equal(formals(require), formals(base::require))
  expect_equal(formals(library), formals(base::library))
})

test_that("shims load package with conflicts silently", {
  col_red <- function() {}
  shims_bind()

  expect_message(library(cli), NA)
  detach("package:cli")

  expect_message(require(cli, quietly = TRUE), NA)
  detach("package:cli")
})

test_that("detaching package removes shims", {
  conflict <- "ns_env"
  skip_if_not(conflict %in% pkg_ls("pkgload") && conflict %in% pkg_ls("rlang"))
  shims_bind()

  library(pkgload)
  library(rlang)
  expect_true(exists(conflict, ".conflicts", inherits = FALSE))

  detach("package:pkgload")
  detach("package:rlang")
  expect_false(exists(conflict, ".conflicts", inherits = FALSE))
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
  # skip on CRAN because library() returns list of all installed packages
  # which might be changing in the background as other packages are installed
  skip_on_cran()
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
