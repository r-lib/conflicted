# trailing () is optional

    Code
      conflicts_prefer(dplyr::lag, dplyr::filter())
    Message
      [conflicted] Will prefer dplyr::lag over any other package.
      [conflicted] Will prefer dplyr::filter over any other package.

# errors if invalid form

    Code
      conflicts_prefer(1)
    Condition
      Error in `conflicts_prefer()`:
      ! All arguments must be in form `pkg::fun` or `pkg::fun()`.
    Code
      conflicts_prefer(foo())
    Condition
      Error in `conflicts_prefer()`:
      ! All arguments must be in form `pkg::fun` or `pkg::fun()`.
    Code
      conflicts_prefer(dplyr::filter(a = 1))
    Condition
      Error in `conflicts_prefer()`:
      ! All arguments must be in form `pkg::fun` or `pkg::fun()`.

