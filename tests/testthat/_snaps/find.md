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

