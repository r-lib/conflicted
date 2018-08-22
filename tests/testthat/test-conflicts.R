context("test-conflicts.R")

test_that("error message is informative", {
  old <- options(crayon.enabled = FALSE)
  on.exit(options(old))

  c1 <- catch_cnd(disambiguate_prefix("x", c("a", "b", "c"))())
  c2 <- catch_cnd(disambiguate_prefix("if", c("a", "b", "c"))())
  c3 <- catch_cnd(disambiguate_infix("%in%", c("a", "b", "c"))())

  expect_known_output(
    {
      cat(c1$message)
      cat("\n\n")
      cat(c2$message)
      cat("\n\n")
      cat(c3$message)
    }, test_path("conflicts-error.txt"))
})


