context("test-shim.R")

test_that("library and require shim arguments match unshimmed", {
  expect_equal(formals(shim_require), formals(require))
  expect_equal(formals(shim_library), formals(library))
})
