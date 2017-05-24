.onAttach <- function(...) {
  options(
    warnPartialMatchArgs = TRUE,
    warnPartialMatchAttr = TRUE,
    warnPartialMatchDollar = TRUE
  )

  strict_activate()
}


strict_deactivate <- function() {
  remove_shims()
  remove_conflicts()
}

strict_activate <- function() {
  register_shims()
  register_conflicts()
}
