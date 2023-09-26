# topo_sort() works

    Code
      intersect(topo_sort(c("testthat", "rlang")), c("testthat", "rlang"))
    Output
      [1] "rlang"    "testthat"
    Code
      intersect(topo_sort(c("testthat", "rlang", "withr")), c("testthat", "rlang",
        "withr"))
    Output
      [1] "rlang"    "withr"    "testthat"

