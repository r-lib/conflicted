test_that("trailing () is optional", {
  withr::defer(prefs_reset())

  expect_snapshot({
    conflicts_prefer(
      dplyr::lag,
      dplyr::filter()
    )
  })
})

test_that("errors if invalid form", {
  expect_snapshot(error = TRUE, {
    conflicts_prefer(1)
    conflicts_prefer(foo())
    conflicts_prefer(dplyr::filter(a = 1))
  })
})
