#' Strict arguments
#'
#' A number of functions in base R have defaults that depend on a global
#' option, or a complicated expression. These shims force you to specify
#' a value for these arguments
#'
#' @param name Name of argument
#' @export
strict_arg <- function(name) {
  strict_abort("Please supply a value for `", name, "` argument.", help = "strict_arg")
}

#' @export
#' @rdname strict_arg
#' @param j Columns to select
strict_drop <- function(j) {
  if (missing(j)) {
    return(FALSE)
  }

  if ((is.numeric(j) || is.character(j)) && length(j) > 1) {
    return(FALSE)
  }

  if (is.logical(j) && sum(j) > 1) {
    return(FALSE)
  }

  strict_abort(
    "Please explicitly specify `drop` when selecting a single column",
    help = "strict_drop"
  )
}

register_shims_risky <- function(env) {
  env_bind(env,
    as.data.frame.character = replace_strings_as_factors(as.data.frame.character),
    as.data.frame.list =      replace_strings_as_factors(as.data.frame.list),
    data.frame =              replace_strings_as_factors(data.frame),
    read.table =              replace_strings_as_factors(utils::read.table),
    `[.data.frame` =          replace_args(`[.data.frame`, drop = quote(strict_drop(j))),
    read.csv =                strict_read_csv,
  )
}

replace_strings_as_factors <- function(fun) {
  replace_args(fun, stringsAsFactors = quote(strict_arg("stringsAsFactors")))
}

replace_args <- function(fun, ...) {
  formals <- as.list(fn_fmls(fun))
  args <- list(...)

  for (arg in names(args)) {
    formals[[arg]] <- args[[arg]]
  }

  formals(fun) <- formals
  fun
}

strict_read_csv <- function(file, header = TRUE, sep = ",", quote = "\"",
                            dec = ".", fill = TRUE, comment.char = "",
                            stringsAsFactors = strict_arg("stringsAsFactors"),
                            ...) {
  utils::read.table(
    file = file,
    header = header,
    sep = sep,
    quote = quote,
    dec = dec,
    fill = fill,
    comment.char = comment.char,
    ...,
    stringsAsFactors = stringsAsFactors
  )
}
# Helpers to find risky functions -----------------------------------------

#' @examples
#' funs <- unlist(lapply(packages, pkg_funs), recursive = FALSE)
#' fmls <- lapply(funs, function(x) as.list(formals(x)))
#'
#' fmls %>% purrr::keep(has_computed_arg, "drop") %>% str()
#' fmls %>% purrr::keep(has_computed_arg, "stringsAsFactors") %>% str()
#' fmls %>% purrr::keep(uses_options) %>% str()
has_computed_arg <- function(formals, arg) {
  has_name(arg, formals) && !is_syntactic_literal(formals[[arg]])
}

uses_options <- function(formals) {
  any(vapply(formals, function(x) is_lang(x, name = "getOption"), logical(1)))
}
