#' Declare many preferences at once
#'
#' This is a wrapper around [conflict_prefer()] that makes it easier to
#' declare many preferences at once with a convenient syntax.
#'
#' @export
#' @param ... Functions to prefer in form `pkg::fun` or `pkg::fun()`.
#' @inheritParams conflict_prefer
#' @examples
#' conflicts_prefer(
#'   dplyr::filter(),
#'   dplyr::lag(),
#' )
conflicts_prefer <- function(..., .quiet = FALSE) {
  calls <- exprs(...)
  # accept pkg::fun() or pkg::fun
  calls <- lapply(calls, standardise_call)

  is_ok <- vapply(calls, is_ns_call, logical(1))
  if (any(!is_ok)) {
    cli::cli_abort(
      "All arguments must be in form {.code pkg::fun} or {.fn pkg::fun}"
    )
  }

  pkgs <- vapply(calls, function(x) as.character(x[[2]]), character(1))
  funs <- vapply(calls, function(x) as.character(x[[3]]), character(1))

  for (i in seq_along(calls)) {
    conflict_preference_register(funs[[i]], pkgs[[i]], quiet = .quiet)
  }

  conflicts_register()

  invisible()
}

standardise_call <- function(x) {
  if (is_call(x, n = 0)) {
    x[[1]]
  } else {
    x
  }
}

is_ns_call <- function(x) {
  is_call(x, "::", n = 2)
}
