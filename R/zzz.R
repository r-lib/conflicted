.onLoad <- function(...) {
  has_moved <<- memoise::memoise(has_moved)
}

.onAttach <- function(...) {
  conflicts_register()
}

# This should really be done on .onDetach(), but because it's called inside of
# detach() it messes up the computation of `pos` inside of `detach()` and it
# detaches the wrong environment
.onUnload <- function(...) {
  conflicts_reset()
}
