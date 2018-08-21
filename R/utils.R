style_name <- function(...) {
  x <- paste0(...)

  if (!is_installed("crayon")) {
    x
  } else {
    crayon::blue(x)
  }
}

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
