.onAttach <- function(...) {
  conflicts_register()
}

.onDetach <- function(...) {
  # detaching when loaded by devtools seems to detach tools:rstudio too :(
  if (pkg_devtools("conflicted"))
    return()

  conflicts_reset()
}
