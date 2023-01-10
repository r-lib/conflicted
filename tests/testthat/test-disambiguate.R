test_that("error message is informative", {
  expect_snapshot(error = TRUE, {
    disambiguate_prefix("x", c("a", "b", "c"))()
    disambiguate_prefix("if", c("a", "b", "c"))()
    disambiguate_infix("%in%", c("a", "b", "c"))()
  })
})

test_that("display namespace if not attached", {
  cnds <- callr::r(function(is_devel) {
    if (is_devel) {
      pkgload::load_all(attach = FALSE)
    }
    list(
      prefix = rlang::catch_cnd(
        conflicted:::disambiguate_prefix("x", c("a", "b", "c"))()
      ),
      infix = rlang::catch_cnd(
        conflicted:::disambiguate_infix("%in%", c("a", "b", "c"))()
      )
    )
  }, list(is_devel = pkgload::is_dev_package("conflicted")))

  expect_snapshot({
    cnds$prefix
    cnds$infix
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
