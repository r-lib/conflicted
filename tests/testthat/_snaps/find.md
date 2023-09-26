# conflict_scout prints usefully

    Code
      conflict_scout("dplyr")
    Message
      0 conflicts
    Code
      conflict_scout(c("rlang", "pkgload"))
    Message
      2 conflicts
      * `ns_env()`: rlang and pkgload
      * `pkg_env()`: rlang and pkgload

# preferences are obeyed

    Code
      conflict_scout(c("rlang", "prefs"))
    Message
      1 conflict
      * `set_names()`: rlang and prefs
    Code
      conflicts_prefer(rlang::set_names())
    Message
      [conflicted] Will prefer rlang::set_names over any other package.
    Code
      conflict_scout(c("rlang", "prefs"))
    Message
      0 conflicts

# using canonical reference

    Code
      conflict_scout(c("testthat", "dplyr", "pipe"))
    Message
      1 conflict
      * `%>%()`: magrittr and pipe

