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

  pkgs[!duplicated(objs)]
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
