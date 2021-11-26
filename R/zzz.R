.onLoad <- function(...) {
  has_moved <<- memoise::memoise(has_moved)
}

.onAttach <- function(...) {
  conflicts_register()
}

.onDetach <- function(...) {
  conflicts_reset()
}
