test_that("topo_sort() works", {
  # Can only use packages that we import or suggest
  expect_snapshot({
    intersect(
      topo_sort(c("testthat", "rlang")),
      c("testthat", "rlang")
    )
    intersect(
      topo_sort(c("testthat", "rlang", "withr")),
      c("testthat", "rlang", "withr")
    )
  })
})
