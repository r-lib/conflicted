#' Declare many preferences at once
#'
#' @description
#' `conflicts_prefer()` allows you to declare "winners" of conflicts,
#' declaring one or many winners at once.
#'
#' See [conflict_prefer()] for more precise control.
#'
#' @section Best practices:
#' I recommend placing a single call to `conflicts_prefer()` at the top of
#' your script, immediately after loading all needed packages with calls to
#' `library()`.
#'
#' @export
#' @param ... Functions to prefer in form `pkg::fun` or `pkg::fun()`.
#' @inheritParams conflict_prefer
#' @examples
#' conflicts_prefer(
#'   dplyr::filter(),
#'   dplyr::lag(),
#' )
#'
#' # or
#' conflicts_prefer(
#'   dplyr::filter,
#'   dplyr::lag,
#' )
conflicts_prefer <- function(..., .quiet = FALSE) {
  calls <- exprs(...)
  # accept pkg::fun() or pkg::fun
  calls <- lapply(calls, standardise_call)

  is_ok <- vapply(calls, is_ns_call, logical(1))
  if (any(!is_ok)) {
    cli::cli_abort(
      "All arguments must be in form {.code pkg::fun} or {.fn pkg::fun}."
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
