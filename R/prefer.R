#' Persistently prefer one function over another
#'
#' @description
#' `conflict_prefer()` allows you to declare "winners" of conflicts.
#' You can either declare a specific pairing (i.e. `dplyr::filter()` beats
#' `base::filter()`), or an overall winner (i.e. `dplyr::filter()` beats
#' all comers). As of conflicted 1.2.0, in most case you should use
#' [conflicts_prefer()] instead as it's both faster and easier to use.
#'
#' Use `conflicted_prefer_all()` to prefer all functions in a package, or
#' `conflicted_prefer_matching()` to prefer functions that match a regular
#' expression.
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
#'
#' # Prefer many functions that match a pattern
#' \dontrun{
#' # Prefer col_* from vroom
#' conflict_prefer_matching("^col_", "vroom")
#' }
#' # Or all functions from a package:
#' \dontrun{
#' # Prefer all tidylog functions over dtplyr functions
#' conflict_prefer_all("tidylog", "dtplyr")
#' }
conflict_prefer <- function(name, winner, losers = NULL, quiet = FALSE) {
  conflict_preference_register(name, winner, losers = losers, quiet = quiet)
  conflicts_register_if_needed(winner)
}

conflict_preference_register <- function(name, winner, losers = NULL, quiet = FALSE) {
  stopifnot(is.character(name), length(name) == 1)
  stopifnot(is.character(winner), length(winner) == 1)
  stopifnot(is.null(losers) || is.character(losers))

  if (env_has(prefs, name)) {
    if (!quiet) {
      cli::cli_inform(
        "{label_conflicted()} Removing existing preference."
      )
    }
  }

  if (!quiet) {
    full <- style_object(winner, name, winner = TRUE)
    if (is.null(losers)) {
      cli::cli_inform(
        "{label_conflicted()} Will prefer {full} over any other package."
      )
    } else {
      alt <- style_object(losers, name)
      cli::cli_inform(
        "{label_conflicted()} Will prefer {full} over {alt}."
      )
    }
  }

  env_bind(prefs, !!name := c(winner, losers))

  invisible()
}


#' @export
#' @param pattern Regular expression used to select objects from the `winner`
#'   package.
#' @rdname conflict_prefer
conflict_prefer_matching <- function(pattern, winner, losers = NULL, quiet = FALSE) {
  names <- grep(pattern, sort(pkg_ls(winner)), value = TRUE)
  names <- losers_intersect(names, losers)

  for (name in names) {
    conflict_preference_register(name, winner, losers = losers, quiet = quiet)
  }

  conflicts_register_if_needed(winner)
}

#' @export
#' @rdname conflict_prefer
conflict_prefer_all <- function(winner, losers = NULL, quiet = FALSE) {
  names <- sort(pkg_ls(winner))
  names <- losers_intersect(names, losers)

  for (name in names) {
    conflict_preference_register(name, winner, losers = losers, quiet = quiet)
  }
  conflicts_register_if_needed(winner)
}

losers_intersect <- function(names, losers) {
  if (is.null(losers)) {
    names
  } else {
    loser_names <- unlist(lapply(losers, pkg_ls))
    names <- intersect(names, loser_names)
  }
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
