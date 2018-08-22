#' Persistently prefer one function over another
#'
#' `conflict_prefer()` allows you to declare "winners" of conflicts.
#' You can either declare a specific pairing (i.e. `dplyr::filter()` beats
#' `base::filter()`), or an overall winner (i.e. `dplyr::filter()` beats
#' all comers).
#'
#' @section Best practices:
#' I recommend placing calls to `conflict_prefer()` at the top of your
#' script, immediately underneath the relevant `library()` call.
#'
#' @param name Name of function.
#' @param winner Name of package that should win the conflict.
#' @param losers Optional vector of packages that should lose the conflict.
#'   If omitted, `winner` will beat all comers.
#' @param quiet If `TRUE`, all output will be suppressed
#' @export
#' @examples
#' # Prefer over all other packages
#' conflict_prefer("filter", "dplyr")
#'
#' # Prefer over specified package or packages
#' conflict_prefer("filter", "dplyr", "base")
#' conflict_prefer("filter", "dplyr", c("base", "filtration"))
conflict_prefer <- function(name, winner, losers = NULL, quiet = FALSE) {
  stopifnot(is.character(name), length(name) == 1)
  stopifnot(is.character(winner), length(winner) == 1)
  stopifnot(is.null(losers) || is.character(losers))

  if (env_has(prefs, name)) {
    if (!quiet)
      message("[conflicted] Removing existing preference")
  }

  if (!quiet) {
    full <- style_name(winner, "::", backtick(name))
    if (is.null(losers)) {
      message("[conflicted] Will prefer ", full, " over any other package")
    } else {
      alt <- style_name(losers, "::", backtick(name))
      message("[conflicted] Will prefer ", full, " over ", paste(alt, collapse = ", "))
    }
  }

  env_bind(prefs, !!name := c(winner, losers))

  if (pkg_attached(winner))
    conflicts_register()

  invisible()
}

prefs_resolve <- function(fun, conflicts) {
  pkgs <- prefs[[fun]]

  if (length(pkgs) == 1) {
    pkgs[[1]]
  } else {
    c(pkgs[[1]], setdiff(conflicts, pkgs))
  }
}

# Environment management --------------------------------------------------

# contains character vectors - first element gives winner,
# subsequent elements (if present) gives losers
prefs <- env()

prefs_ls <- function() {
  env_names(prefs)
}

prefs_reset <- function() {
  env_unbind(prefs, env_names(prefs))
}
