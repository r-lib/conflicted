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

unique_obj <- function(name, pkgs) {
  objs <- lapply(pkgs, getExportedValue, name)
  names(objs) <- pkgs

  # Finding the namespace where a function is really defined
  env_names <- map_chr(objs, function(obj) {
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

    if (is.null(canonical_obj)) {
      return("")
    }

    if (identical(unname(canonical_obj)[[1]], obj)) {
      names(canonical_obj)
    } else {
      ""
    }
  })

  canonical_names <- unique(env_names[env_names != ""])
  canonical_pos <- set_names(match(canonical_names, env_names), canonical_names)

  canonical_objs <- c(objs[canonical_pos], objs)
  canonical_pkgs <- c(canonical_names, pkgs)

  canonical_pkgs[!duplicated(canonical_objs)]
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
