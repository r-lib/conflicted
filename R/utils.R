invert <- function(x) {
  if (length(x) == 0) return()
  stacked <- utils::stack(x)
  tapply(as.character(stacked$ind), stacked$values, list)
}

pkg_devtools <- function(name) {
  ns <- .getNamespace(name)
  if (is.null(ns)) {
    return(FALSE)
  }

  !is.null(ns$.__DEVTOOLS__)
}

on_detach <- function(pkg, fun) {
  force(fun)

  done <- FALSE
  call_once <- function(...) {
    if (done) return()
    done <<- TRUE
    fun()
  }

  setHook(packageEvent(pkg, "detach"), call_once)
}

map2 <- function(.x, .y, .f, ...) {
  mapply(.f, .x, .y, MoreArgs = list(...), SIMPLIFY = FALSE)
}

map_chr <- function(.x, .f, ...) {
  vapply(.x, .f, ..., FUN.VALUE = character(1))
}

imap_chr <- function(.x, .f, ...) {
  out <- character(length(.x))
  for (i in seq_along(.x)) {
    out[[i]] <- .f(.x[[i]], names(.x)[[i]], ...)
  }

  set_names(out, names(.x))
}

unique_obj <- function(name, pkgs) {
  objs <- lapply(pkgs, getExportedValue, name)
  names(objs) <- pkgs

  canonical <- canonical_objs(objs, name)

  canonical_objs <- c(canonical, objs)
  canonical_pkgs <- c(names(canonical), pkgs)

  canonical_pkgs[!duplicated(canonical_objs)]
}

canonical_objs <- function(objs, name) {
  seen <- list()

  # Finding the namespace where a function is really defined
  env_names <- imap_chr(objs, function(obj, pkg) {
    canonical_obj <- tryCatch(
      {
        canonical_pkg <- getNamespaceName(environment(obj))
        # Double-check that this is actually the correct object,
        # e.g., devtools does interesting things here
        canonical_obj <- getExportedValue(canonical_pkg, name)
        set_names(list(canonical_obj), canonical_pkg)
      },
      error = function(e) NULL
    )


    # Error getting name or exported value?
    if (is.null(canonical_obj)) {
      return("")
    }

    # Roundtrip failed?
    if (!identical(unname(canonical_obj)[[1]], obj)) {
      return("")
    }

    # Happy path: canonical package is attached?
    canonical <- names(canonical_obj)
    if (canonical %in% names(objs)) {
      return(canonical)
    }

    # More work needed: we pick the first package
    if (canonical %in% names(seen)) {
      # Second pass, we had found a package with that function before
      return(seen[[canonical]])
    }

    # We are first, recording
    seen[[canonical]] <<- pkg
    pkg
  })

  canonical_names <- unique(env_names[env_names != ""])
  canonical_pos <- set_names(match(canonical_names, env_names), canonical_names)

  set_names(objs[canonical_pos], canonical_names)
}

style_object <- function(pkg, name, winner = FALSE) {
  paste0(
    if (winner) cli::style_bold(cli::col_blue(pkg)) else cli::col_blue(pkg),
    "::",
    backtick(name)
  )
}

label_conflicted <- function() {
  cli::col_grey("[conflicted]")
}

backtick <- function(x) {
  ifelse(x == make.names(x), x, paste0("`", x, "`"))
}


compact <- function(x) {
  empty <- vapply(x, is_empty, logical(1))
  x[!empty]
}

cat_line <- function(...) {
  cat(paste0(..., "\n", collapse = ""))
}
