.onAttach <- function(...) {
  conflicts_register()
}

.onDetach <- function(...) {
  conflicts_reset()
}
