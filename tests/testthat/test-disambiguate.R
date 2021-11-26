test_that("error message is informative", {
  expect_snapshot(error = TRUE, {
    disambiguate_prefix("x", c("a", "b", "c"))()
    disambiguate_prefix("if", c("a", "b", "c"))()
    disambiguate_infix("%in%", c("a", "b", "c"))()
  })
})


test_that("can save active binding without error", {
  env <- env(
    a = disambiguate_prefix("x", c("a", "b", "c")),
    b = disambiguate_infix("y", c("a", "b", "c"))
  )

  expect_error(save(a, envir = env, file = tempfile()), NA)
  expect_error(save(b, envir = env, file = tempfile()), NA)
})
