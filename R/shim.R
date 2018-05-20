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

  package <- package_name(enquo(package), character.only = character.only)
  on.exit(register_conflicts())

  base::library(
    package,
    help = help,
    pos = pos,
    lib.loc = lib.loc,
    character.only = TRUE,
    logical.return = logical.return,
    warn.conflicts = FALSE,
    quietly = quietly,
    verbose = verbose
  )
}

shim_require <- function(package,
                         lib.loc = NULL,
                         quietly = FALSE,
                         warn.conflicts = TRUE,
                         character.only = FALSE) {

  package <- package_name(enquo(package), character.only = character.only)
  on.exit(register_conflicts())

  base::require(
    package,
    lib.loc = lib.loc,
    quietly = quietly,
    warn.conflicts = FALSE,
    character.only = TRUE
  )

}

package_name <- function(package, character.only = FALSE) {
  if (!character.only) {
    package <- as.character(get_expr(package))
  } else {
    package <- eval_tidy(package)
  }
  if (length(package) != 1L)
    stop("'package' must be of length 1")
  if (is.na(package) || (package == ""))
    stop("invalid package name")

  package
}
