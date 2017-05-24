.onAttach <- function(...) {
  options(
    warnPartialMatchArgs = TRUE,
    warnPartialMatchAttr = TRUE,
    warnPartialMatchDollar = TRUE
  )

  register_shims()
  register_conflicts()
}
