#' Find conflicts amongst a set of packages
#'
#' `conflicts_find()` is the workhorse behind the conflicted package. You can
#' call it directly yourself if you want to see all conflicts before hitting
#' them in practice.
#
#' @param pkgs Set of packages for which to report conflicts. If `NULL`,
#'   the default, will report conflicts for all loaded packages
#' @return A named list of character vectors. The names are functions and
#'   the values are the packages where they appear. If there is only a single
#'   package listed, it means that an automated disambiguation has selected
#'   that function.
#'
#'   A user friendly print method displays the result as bulleted list.
#' @export
#' @examples
#' conflicts_find()
conflicts_find <- function(pkgs = NULL) {
  pkgs <- pkgs %||% pkgs_attached()
  objs <- lapply(pkgs, pkg_ls)
  names(objs) <- pkgs

  index <- invert(objs)
  potential <- Filter(function(x) length(x) > 1, index)

  # Only consider it a conflict if the objects are actually different
  unique <- Map(unique_obj, names(potential), potential)
  conflicts <- Filter(function(x) length(x) > 1, unique)

  # superset principle: ignore single conflict with base packages
  # unless attr(f, "conflicted_superset") is FALSE
  conflicts <- map2(names(conflicts), conflicts, superset_principle)

  # a deprecated function should never conflict with any other function
  conflicts <- map2(names(conflicts), conflicts, drop_deprecated)

  # apply declared user preferences
  for (fun in ls(prefs)) {
    if (!has_name(conflicts, fun))
      next

    conflicts[[fun]] <- prefs_resolve(fun, conflicts[[fun]])
  }

  structure(conflicts, class = "conflict_report")
}

#' @export
print.conflict_report <- function(x, ...) {
  pkg_names <- function(pkgs) {
    if (length(pkgs) == 1) {
      paste0("[", style_name(pkgs), "]")
    } else {
      paste0(style_name(pkgs), collapse = ", ")
    }
  }

  x <- compact(x)
  cat_line(length(x), " conflicts")

  if (length(x) == 0) {
    return(invisible(x))
  }

  x <- x[order(names(x))]
  fun <- paste0("`", names(x), "`")
  pkgs <-  vapply(x, pkg_names, character(1))

  bullets <- paste0("* ", format(fun),  ": ", pkgs, "\n", collapse = "")
  cat(bullets)
  invisible(x)
}

superset_principle <- function(fun, pkgs) {
  non_base <- setdiff(pkgs, base_packages)
  if (length(non_base) == 0) {
    # all base, so no conflicts
    character()
  } else if (length(non_base) == 1) {
    # only one, so assume it obeys superset principle
    if (not_superset(fun, non_base)) {
      pkgs
    } else {
      non_base
    }
  } else {
    non_base
  }
}

drop_deprecated <- function(fun, pkgs) {
  is_dep <- vapply(pkgs, function(pkg) is_deprecated_mem(fun, pkg), logical(1))
  pkgs[!is_dep]
}

is_deprecated_mem <- memoise::memoise(function(fun, pkg) {
  obj <- getExportedValue(pkg, fun)
  is_deprecated(obj)
})

is_deprecated <- function(x) {
  if (!is.function(x)) {
    return(FALSE)
  }

  body <- body(x)
  if (length(body) < 2 || !is_call(body, "{"))
    return(FALSE)

  is_call(body[[2]], ".Deprecated")
}


not_superset <- function(fun, pkg) {
  pkg == "dplyr" && fun %in% c("lag", "filter")
}
