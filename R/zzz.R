.onAttach <- function(...) {
  options(
    warnPartialMatchArgs = TRUE,
    warnPartialMatchDollar = TRUE,
    warnPartialMatchDollar = TRUE
  )

  register_shims()
  register_conflicts()
}
