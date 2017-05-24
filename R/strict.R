#' @import rlang
NULL


#' Is code run in a strict environment?
#'
#' @export
is_strict <- function() {
  "strict_conflicts" %in% search() && "strict_shims" %in% search()
}
