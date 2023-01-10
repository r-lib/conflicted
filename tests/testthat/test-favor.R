test_that("trailing () is optional", {
  withr::defer(prefs_reset())

  expect_snapshot({
    conflicts_prefer(
      dplyr::lag,
      dplyr::filter()
    )
  })
})
