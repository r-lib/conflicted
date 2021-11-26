test_that("can register preference over all or selected packages", {
  on.exit(prefs_reset())

  conflict_prefer("x1", "pkga", quiet = TRUE)
  conflict_prefer("x2", "pkga", "pkgb", quiet = TRUE)
  conflict_prefer("x3", "pkga", c("pkgb", "pkgc"), quiet = TRUE)

  expect_setequal(prefs_ls(), c("x1", "x2", "x3"))
})

# resolution --------------------------------------------------------------

test_that("length 1 vector beats all comers", {
  on.exit(prefs_reset())

  conflict_prefer("x1", "pkga", quiet = TRUE)
  expect_equal(prefs_resolve("x1"), "pkga")
})

test_that("length n vector beats listed others", {
  on.exit(prefs_reset())

  conflict_prefer("x1", "pkga", "pkgb", quiet = TRUE)
  expect_equal(prefs_resolve("x1", c("pkga", "pkgb")), "pkga")
  expect_equal(prefs_resolve("x1", c("pkga", "pkgb", "pkgc")), c("pkga", "pkgc"))
})


# en masse ----------------------------------------------------------------

test_that("can register preference for multiple functions", {
  pkgload::load_all(test_path("funmatch"), quiet = TRUE)
  on.exit({
    pkgload::unload("funmatch")
    prefs_reset()
  })

  conflict_prefer_all("funmatch", quiet = TRUE)
  expect_setequal(prefs_ls(), c("mean", "pi"))
  prefs_reset()

  conflict_prefer_matching("m", "funmatch", quiet = TRUE)
  expect_setequal(prefs_ls(), "mean")
  prefs_reset()
})
