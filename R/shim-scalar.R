register_shim_scalar <- function(env) {
  env_bind(env,
    sample = strict_sample,
    diag = strict_diag
  )
}

#' Strict behaviour for functions with special scalar behaviour
#'
#' [sample()] and [diag()] behave differently depending on whether their
#' first argument is a scalar or a function. These shims throw an error
#' when given a scalar to force you to pick a safer alternative.
#'
#' @param x,size,replace,prob,nrow,ncol Passed on to [sample()] and [diag()]
#' @export
#' @examples
#' lax({
#'   sample(5:3)
#'   sample(5:4)
#'   sample(5:5)
#'
#'   diag(5:3)
#'   diag(5:4)
#'   diag(5:5)
#' })
#'
#' \dontrun{
#'   sample(5:5)
#'   diag(5)
#' }
strict_sample <- function(x, size = length(x), replace = FALSE, prob = NULL) {
  if (length(x) == 1) {
    strict_abort(
      "`sample()` has surprising behaviour when `x` is a scalar.\n",
      "Use `sample.int()` instead.",
      help = "strict_sample"
    )
  } else {
    sample(
      x = x,
      size = size,
      replace = replace,
      prob = prob
    )
  }
}

#' @export
#' @rdname strict_sample
strict_diag <- function(x = 1, nrow, ncol) {
  if (length(x) == 1) {
    strict_abort(
      "`diag()` has surprising behaviour when `x` is a scalar.\n",
      "Use `diag(rep(1, x))` instead.",
      help = "strict_diag"
    )
  } else {
    base::diag(x = x, nrow = nrow, ncol = ncol)
  }
}
