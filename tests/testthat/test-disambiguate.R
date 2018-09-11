context("test-disambiguate.R")

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
    }, test_path("test-disambiguate.txt"))
})


test_that("can save active binding without error", {
  env <- env(
    a = disambiguate_prefix("x", c("a", "b", "c")),
    b = disambiguate_infix("y", c("a", "b", "c"))
  )

  expect_error(save(a, envir = env, file = tempfile()), NA)
  expect_error(save(b, envir = env, file = tempfile()), NA)
})
