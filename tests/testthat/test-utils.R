test_that("canonical_objs()", {
  expect_equal(
    canonical_objs(
      list(
        magrittr = dplyr::`%>%`,
        testthat = dplyr::`%>%`,
        dplyr = dplyr::`%>%`
      ),
      "%>%"
    ),
    list(magrittr = dplyr::`%>%`)
  )

  # Only using packages that are attached, in order
  expect_equal(
    canonical_objs(
      list(
        testthat = dplyr::`%>%`,
        dplyr = dplyr::`%>%`
      ),
      "%>%"
    ),
    list(testthat = dplyr::`%>%`)
  )

  expect_equal(
    canonical_objs(
      list(
        dplyr = dplyr::`%>%`,
        testthat = dplyr::`%>%`
      ),
      "%>%"
    ),
    list(dplyr = dplyr::`%>%`)
  )
})
