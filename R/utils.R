strict_abort <- function(..., help = NULL) {
  msg <- paste0(..., collapse = "")
  if (!is.null(help)) {
    msg <- paste0(msg, "\nPlease see ?", help, " for more details")
  }

  # not currently used; pending RStudio support
  col <- paste(style_strict("[strict] "), crayon::black(msg))
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
