#' Strict arguments
#'
#' A number of functions in base R have defaults that depend on a global
#' option, or a complicated expression. These shims force you to specify
#' a value for these arguments
#'
#' @param name Name of argument
#' @export
strict_arg <- function(name) {
  strict_abort("Must supply a value for `", name, "` argument", help = "strict_arg")
}

register_risky_shims <- function(env) {
  env_bind(env,
    `[.data.frame` = force_strict(`[.data.frame`, "drop"),
    as.data.frame.character = force_strict(as.data.frame.character, "stringsAsFactors"),
    as.data.frame.list = force_strict(as.data.frame.list, "stringsAsFactors"),
    data.frame = force_strict(data.frame, "stringsAsFactors"),
    read.table = force_strict(utils::read.table, "stringsAsFactors"),
    read.csv = strict_read.csv
  )
}

force_strict <- function(fun, args) {
  formals <- as.list(fn_fmls(fun))

  for (arg in args) {
    if (has_name(arg, formals) && !is_syntactic_literal(formals[[arg]])) {
      formals[[arg]] <- expr(strict_arg(!!arg))
    }
  }

  formals(fun) <- formals
  fun
}

strict_read.csv <- function(file, header = TRUE, sep = ",", quote = "\"",
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
