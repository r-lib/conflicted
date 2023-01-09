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

  # a function doesn't conflict with a non-dataset
  conflicts <- map2(names(conflicts), conflicts, function_lookup)

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
  n <- attr(x, "n")
  cli::cli_text("{n} conflict{?s}")

  if (length(x) == 0) {
    return(invisible(x))
  }

  x <- x[order(names(x))]
  fun <- map_chr(names(x), function(x) sprintf("{.fn %s}", x))
  pkgs <- map_chr(x, function(x) cli::format_inline("{.pkg {x}}"))
  bullets <- paste0(fun, ": ", pkgs)
  names(bullets) <- rep("*", length(bullets))

  cli::cli_bullets(bullets)
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
      character()
    } else {
      pkgs
    }
  } else {
    pkgs
  }
}

function_lookup <- function(fun, pkgs) {
  # Only apply this rule if exaclty two conflicts
  if (length(pkgs) != 2) {
    return(pkgs)
  }

  pkg1 <- getExportedValue(pkgs[[1]], fun)
  pkg2 <- getExportedValue(pkgs[[2]], fun)

  if (is.function(pkg1) != is.function(pkg2)) {
    character()
  } else {
    pkgs
  }

}

is_superset <- function(fun, pkg, base) {
  # Special case dplyr::lag() which looks like it should agree
  if (pkg == "dplyr" && fun == "lag")
    return(FALSE)

  pkg_obj <- getExportedValue(pkg, fun)
  # If it's a standardGeneric, assume the author know's what they're doing
  if (methods::is(pkg_obj, "standardGeneric")) {
    return(TRUE)
  }

  base_obj <- getExportedValue(base, fun)
  if (!is.function(pkg_obj) || !is.function(base_obj))
    return(FALSE)

  # Assume any function that just takes ... passes them on appropriately,
  # like BiocGenerics::table()
  args_pkg <- names(fn_fmls(pkg_obj))
  if (identical(args_pkg, "..."))
    return(TRUE)

  if (is.primitive(base_obj)){
    return(FALSE)
  }

  args_base <- names(fn_fmls(base_obj))

  # To be a superset, all base arguments must be included in the pkg funtion
  all(args_base %in% args_pkg)
}

drop_moved <- function(fun, pkgs) {
  is_dep <- vapply(pkgs, has_moved, fun = fun, FUN.VALUE = logical(1))
  pkgs[!is_dep]
}


# memoised onLoad
has_moved <- function(pkg, fun, obj = NULL) {
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
}
