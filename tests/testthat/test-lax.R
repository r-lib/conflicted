context("lax")

test_that("lax suppresses warnings too", {
  df <- data.frame(xyz = 1)
  expect_warning(df$x, "Partial match")
  expect_warning(lax(df$x), NA)
})
