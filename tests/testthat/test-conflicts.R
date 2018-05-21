context("test-conflicts.R")

test_that("error message is informative", {
  old <- options(crayon.enabled = FALSE)
  on.exit(options(old))

  fun <- conflict_binding("x", c("a", "b", "c"))
  c <- catch_cnd(fun())

  expect_known_output(cat(c$message), test_path("conflicts-error.txt"))
})
