test_that("conflict_scout prints usefully", {
  expect_snapshot({
    conflict_scout("dplyr")
    conflict_scout(c("rlang", "pkgload"))
  })
})

test_that("primitive functions are never supersets", {
  pkgload::load_all(test_path("primitive"), quiet = TRUE)
  on.exit(pkgload::unload("primitive"))

  expect_false(is_superset("sum", "primitive", "base"))
  expect_equal(
    superset_principle("sum", c("primitive", "base")),
    c("primitive", "base")
  )
})

test_that("superset", {
  # by definition/design, there are no real conflicts in base functions
  expect_equal(superset_principle("cbind", c("base", "methods")), character())

  skip_if_not_installed("Matrix")
  # Automatically created S4 generics obey the superset principle
  expect_equal(superset_principle("print", c("base", "Matrix")), character())
  # Even if the arguments have been customised
  expect_equal(superset_principle("rcond", c("base", "Matrix")), character())
})

test_that("functions aren't conflicts with non-functions", {
  pkgload::load_all(test_path("funmatch"), quiet = TRUE)
  on.exit(pkgload::unload("funmatch"))

  expect_equal(function_lookup("pi", c("base", "funmatch")), character())
  expect_equal(function_lookup("median", c("stats", "funmatch")), character())
})

test_that("can find conflicts with data", {
  pkgload::load_all(test_path("data"), quiet = TRUE)
  on.exit(pkgload::unload("data"))

  expect_named(conflict_scout(c("datasets", "data")), "mtcars")
})

test_that("preferences are obeyed", {
  pkgload::load_all(test_path("prefs"), quiet = TRUE)
  withr::defer(pkgload::unload("prefs"))

  on.exit(prefs_reset(), add = TRUE)

  expect_snapshot({
    conflict_scout(c("rlang", "prefs"))
    conflicts_prefer(rlang::set_names())
    conflict_scout(c("rlang", "prefs"))
  })
})

test_that("using canonical reference", {
  pkgload::load_all(test_path("pipe"), quiet = TRUE)
  withr::defer(pkgload::unload("pipe"))

  expect_snapshot({
    conflict_scout(c("testthat", "dplyr", "pipe"))
  })
})

# moved functions ----------------------------------------------------

test_that(".Deprecated call contains function name", {
  f <- function() {
    .Deprecated("pkg::x")
  }

  expect_false(has_moved("pkg", "foo", f))
  expect_true(has_moved("pkg", "x", f))
})

test_that("returns FALSE for weird inputs", {
  expect_false(has_moved(obj = 20))
  expect_false(has_moved(obj = mean))

  f <- function() {}
  expect_false(has_moved(obj = mean))

  f <- function() {
    .Deprecated()
  }
  expect_false(has_moved(obj = mean))

  f <- function() {
    .Deprecated(1)
  }
  expect_false(has_moved(obj = mean))

})
