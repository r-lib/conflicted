#' @section Resolving conflicts:
#'
#' To permanently resolve a conflict within a session, use conflict_prefer():
#'
#' \preformatted{
#' library(conflicted)
#' library(dplyr)
#'
#' conflict_prefer("filter", "dplyr")
#' }
#'
#' @keywords internal
#' @import rlang
"_PACKAGE"
