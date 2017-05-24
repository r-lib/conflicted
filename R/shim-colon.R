#' Strict version of `:`
#'
#' This version of `:` throws an error if `from` is positive and `to` is
#' zero, to make the error more obvious if you've used `1:length(x)` instead
#' of [seq_along()]
#'
#' @param from,to Passed on to [seq()]
#' @export
#' @examples
#' x <- numeric()
#' seq_along(x)
#' lax(1:length(x))
shim_colon <- function(from, to) {
  if (to == 0L && from > 0) {
    strict_abort(
      "Tried to create descending sequence ", from, ":", to, ". ",
      "Do you want to `seq_along()` instead?\n",
      help = "shim_colon"
    )
  } else {
    seq(from, to)
  }
}
