register_shims_apply <- function(env) {
  env_bind(env,
    sapply = strict_sapply,
    apply = strict_apply
  )
}

#' Strict version of `sapply()`
#'
#' `sapply()` is dangerous for programmatic usage because it is type-unstable:
#' you can't predict in advance what it's going to return just be reading the
#' code. Instead use [vapply()], which has an additional argument `FUN.VALUE`,
#' that
#'
#' @param ... Ignored
#' @export
#' @examples
#' df <- data.frame(
#'  a = 1,
#'  b = "a",
#'  c = Sys.time(),
#'  d = ordered("a"),
#'  stringsAsFactors = FALSE
#' )
#'
#' # A list
#' base::sapply(df, class)
#' # A matrix
#' base::sapply(df[3:4], class)
#' # A vector
#' base::sapply(df[1:2], class)
strict_sapply <- function(...) {
  strict_abort("Please use `vapply()` instead of `sapply()`.", help = "strict_sapply")
}

#' Strict version of `apply()`
#'
#' It is a bad idea to use `apply()` with data frames because it coerces it's
#' input to a matrix. This generally leads to poor performance, and will give
#' unexpected results if your data frame gains non-numeric columns in the future
#'
#' @param X,MARGIN,FUN,... Passed on to [apply()]
#' @export
strict_apply <- function(X, MARGIN, FUN, ...)  {
  if (is.data.frame(X)) {
    strict_abort(
      "`apply()` coerces `X` to a matrix so is dangerous to use with data frames.",
      "Please use `lapply()` instead.")
  }

  apply(X, MARGIN, FUN, ...)
}

