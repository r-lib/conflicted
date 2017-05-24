
strict_sample <- function(x, size = length(x), replace = FALSE, prob = NULL) {
  x[sample.int(length(x), size, replace, prob)]
}

strict_diag <- function(x = 1, nrow, ncol) {
  dims <- length(dim(x))

  if (dims > 2) {
    abort("`x` must be a matrix, vector or 1d array.")
  } else if (dims == 2) {
    # dispatch to base
    base::diag(x, nrow, ncol)
  } else {
    # need to test
    nrow <- if (!missing(nrow)) nrow else length(x)
    ncol <- if (!missing(ncol)) ncol else nrow

    out <- matrix(x, nrow = nrow, ncol = ncol)
    diag(out) <- x
    out
  }
}
