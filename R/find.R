#' Find conflicts amongst a set of packages
#'
#' `conflict_scout()` is the workhorse behind the conflicted package. You can
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
#' conflict_scout()
conflict_scout <- function(pkgs = NULL) {
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

  # a function that has moved packages should never conflict
  conflicts <- map2(names(conflicts), conflicts, drop_moved)

  # apply declared user preferences
  for (fun in ls(prefs)) {
    if (!has_name(conflicts, fun))
      next

    conflicts[[fun]] <- prefs_resolve(fun, conflicts[[fun]])
  }

  conflicts <- compact(conflicts)

  new_conflict_report(conflicts)
}

new_conflict_report <- function(conflicts, n = length(conflicts)) {
  structure(conflicts, n = n, class = "conflict_report")
}

#' @export
`[.conflict_report` <- function(x, ...) {
  new_conflict_report(NextMethod(), n = attr(x, "n"))
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

  n <- attr(x, "n")
  cat_line(n, " conflict", if (n != 1) "s", if (n > 0) ":")

  if (length(x) == 0) {
    return(invisible(x))
  }

  x <- x[order(names(x))]
  fun <- paste0("`", names(x), "`")
  pkgs <-  vapply(x, pkg_names, character(1))

  cat_line("* ", format(fun),  ": ", pkgs)
  if (n > length(x)) {
    cat_line("...")
  }
  invisible(x)
}

superset_principle <- function(fun, pkgs) {
  base <- intersect(pkgs, base_packages)
  non_base <- setdiff(pkgs, base_packages)

  if (length(non_base) == 0) {
    # all base, so no conflicts
    character()
  } else if (length(non_base) == 1) {
    # only one so see if it assumes superset principle
    if (is_superset(fun, non_base, base = base)) {
      non_base
    } else {
      pkgs
    }
  } else {
    non_base
  }
}

is_superset <- function(fun, pkg, base) {
  # Special case dplyr::lag() which looks like it should agree
  if (pkg == "dplyr" && fun == "lag")
    return(FALSE)

  pkg_obj <- getExportedValue(pkg, fun)
  base_obj <- getExportedValue(base, fun)
  if (!is.function(pkg_obj) || !is.function(base_obj))
    return(FALSE)

  # Assume any function that just takes ... passes them on appropriately,
  # like BiocGenerics::table()
  args_pkg <- names(fn_fmls(pkg_obj))
  if (identical(args_pkg, "..."))
    return(TRUE)
  args_base <- names(fn_fmls(base_obj))

  # To be a superset, all base arguments must be included in the pkg funtion
  all(args_base %in% args_pkg)
}

drop_moved <- function(fun, pkgs) {
  is_dep <- vapply(pkgs, has_moved, fun = fun, FUN.VALUE = logical(1))
  pkgs[!is_dep]
}


has_moved <- memoise::memoise(function(pkg, fun, obj = NULL) {
  if (is.null(obj)) {
    obj <- getExportedValue(pkg, fun)
  }

  if (!is.function(obj)) {
    return(FALSE)
  }

  body <- body(obj)
  if (length(body) < 2 || !is_call(body, "{"))
    return(FALSE)

  if (!is_call(body[[2]], ".Deprecated"))
    return(FALSE)

  if (length(body[[2]]) < 2)
    return(FALSE)

  new <- body[[2]][[2]]
  if (!is.character(new))
    return(FALSE)

  grepl(paste0("::", fun), new)
})
