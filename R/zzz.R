.onAttach <- function(...) {
  options(
    warnPartialMatchArgs = TRUE,
    warnPartialMatchAttr = TRUE,
    warnPartialMatchDollar = TRUE
  )

  strict_activate()
}


#' Manually activate and deactive strict mode
#'
#' For experts only.
#'
#' @keywords internal
#' @export
strict_deactivate <- function() {
  remove_shims()
  remove_conflicts()
}

#' @export
#' @rdname strict_deactivate
strict_activate <- function() {
  register_shims()
  register_conflicts()
}
