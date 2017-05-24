strict_abort <- function(..., help = NULL) {
  # Need to use colour when available in RStudio tracebacks
  msg <- paste0("[strict]\n", ..., collapse = "")
  if (!is.null(help)) {
    msg <- paste0(msg, "\nPlease see ?", help, " for more details")
  }

  abort(msg)
}

style_strict <- function(...) {
  crayon::bgRed(crayon::white(paste0(..., collapse = "")))
}

invert <- function(x) {
  if (length(x) == 0) return()
  stacked <- utils::stack(x)
  tapply(as.character(stacked$ind), stacked$values, list)
}
