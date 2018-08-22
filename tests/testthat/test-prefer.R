context("test-prefer")

test_that("can register preference over all or selected packages", {
  on.exit(prefs_reset())

  conflict_prefer("x1", "pkga")
  conflict_prefer("x2", "pkga", "pkgb")
  conflict_prefer("x3", "pkga", c("pkgb", "pkgc"))

  expect_setequal(prefs_ls(), c("x1", "x2", "x3"))
})

# resolution --------------------------------------------------------------

test_that("length 1 vector beats all comers", {
  on.exit(prefs_reset())

  conflict_prefer("x1", "pkga")
  expect_equal(prefs_resolve("x1"), "pkga")
})

test_that("length n vector beats listed others", {
  on.exit(prefs_reset())

  conflict_prefer("x1", "pkga", "pkgb")
  expect_equal(prefs_resolve("x1", c("pkga", "pkgb")), "pkga")
  expect_equal(prefs_resolve("x1", c("pkga", "pkgb", "pkgc")), c("pkga", "pkgc"))
})
