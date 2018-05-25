shim_library <- function(package,
                         help,
                         pos = 2,
                         lib.loc = NULL,
                         character.only = FALSE,
                         logical.return = FALSE,
                         warn.conflicts = TRUE,
                         quietly = FALSE,
                         verbose = getOption("verbose")
                         ) {

  if (!missing(package)) {
    conflicts_reset()
    on.exit(conflicts_register())

    package <- package_name(enquo(package), character.only = character.only)
    library(
      package,
      pos = pos,
      lib.loc = lib.loc,
      character.only = TRUE,
      logical.return = logical.return,
      warn.conflicts = FALSE,
      quietly = quietly,
      verbose = verbose
    )
  } else if (!missing(help)) {
    help <- package_name(enquo(help), character.only = character.only)
    library(
      help = help,
      character.only = TRUE
    )
  } else {
    library(
      lib.loc = lib.loc,
      logical.return = logical.return
    )
  }

}

shim_require <- function(package,
                         lib.loc = NULL,
                         quietly = FALSE,
                         warn.conflicts = TRUE,
                         character.only = FALSE) {

  package <- package_name(enquo(package), character.only = character.only)
  conflicts_reset()
  on.exit(conflicts_register())

  require(
    package,
    lib.loc = lib.loc,
    quietly = quietly,
    warn.conflicts = FALSE,
    character.only = TRUE
  )

}

package_name <- function(package, character.only = FALSE) {
  if (!character.only) {
    package <- as.character(quo_expr(package))
  } else {
    package <- eval_tidy(package)
  }

  if (!is.character(package) || length(package) != 1L) {
    abort("`package` must be character vector of length 1.")
  }
  if (is.na(package) || (package == "")) {
    abort("`package` must not be NA or ''.")
  }

  package
}
