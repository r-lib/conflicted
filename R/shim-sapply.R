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
  strict_abort("Please use `vapply()` instead of `sapply()`", help = "strict_sapply")
}

