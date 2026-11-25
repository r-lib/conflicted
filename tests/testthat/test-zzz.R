test_that("unloading removes shims", {
  # Do in separate process to avoid interferring with tests
  in_search <- callr::r(function() {
    library(conflicted)
    pkgload::unload("conflicted")
    ".conflicts" %in% search()
  })
  expect_false(in_search)
})

test_that("preferences survive startup when default packages attach", {
  skip_if_not_installed("dplyr")

  profile <- withr::local_tempfile()
  writeLines(c(
    "library(dplyr)",
    "conflicted::conflicts_prefer(dplyr::filter, .quiet = TRUE)"
  ), profile)
  withr::local_envvar(c(
    R_PROFILE_USER = profile,
    R_LIBS = paste(.libPaths(), collapse = .Platform$path.sep),
    R_DEFAULT_PACKAGES = "datasets,utils,grDevices,graphics,stats,methods"
  ))

  exe <- if (.Platform$OS.type == "windows") "Rterm.exe" else "R"
  output <- system2(
    file.path(R.home("bin"), exe),
    c(
      "--slave", "--no-environ", "--no-site-file", "--no-restore", "--no-save",
      "-e", shQuote('cat("uses dplyr filter:", identical(filter, dplyr::filter))')
    ),
    stdout = TRUE,
    stderr = TRUE
  )
  expect_match(output, "uses dplyr filter: TRUE", all = FALSE)
})

test_that("preferences only apply while their winner is available", {
  skip_if_not_installed("dplyr")

  result <- callr::r(function() {
    library(conflicted)
    conflicts_prefer(dplyr::filter, .quiet = TRUE)
    before <- identical(filter, stats::filter)

    library(dplyr)
    during <- identical(filter, dplyr::filter)
    conflicts_prefer(utils::filter, .quiet = TRUE)
    unresolved <- "filter" %in% names(conflict_scout())

    conflicts_prefer(dplyr::filter, .quiet = TRUE)
    detach("package:dplyr")
    after <- identical(filter, stats::filter)

    c(before = before, during = during, unresolved = unresolved, after = after)
  })
  expect_equal(
    result,
    c(before = TRUE, during = TRUE, unresolved = TRUE, after = TRUE)
  )
})
