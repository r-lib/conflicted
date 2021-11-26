test_that("detaching removes shims", {
  # Do in separate process to avoid interferring with tests
  in_search <- callr::r(function() {
    library(conflicted)
    detach("package:conflicted")
    ".conflicts" %in% search()
  })
  expect_false(in_search)
})
