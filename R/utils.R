strict_abort <- function(...) {
  msg <- paste0(..., collapse = "")
  # not currently used; pending RStudio support
  col <- paste(style_strict("[strict] "), crayon::black(msg))
  abort(msg)
}

style_strict <- function(...) {
  crayon::bgRed(crayon::white(paste0(..., collapse = "")))
}
