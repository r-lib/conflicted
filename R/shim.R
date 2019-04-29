shims_bind <- function(env = caller_env()) {
  if (getRversion() >= "3.6.0") {
    env_bind(env,
      library = shim_library_3_6,
      require = shim_require_3_6
    )
  } else {
    env_bind(env,
      library = shim_library_3_1,
      require = shim_require_3_1
    )
  }

}

# library -----------------------------------------------------------------

shim_library_3_1 <- function(package,
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
    package <- package_name(enquo(package), character.only = character.only)

    conflicts_reset()
    on.exit(conflicts_register())
    on_detach(package, function() conflicts_remove(package))

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

if (getRversion() >= "3.6.0") {
  shim_library_3_6 <- function(package,
                               help,
                               pos = 2,
                               lib.loc = NULL,
                               character.only = FALSE,
                               logical.return = FALSE,
                               warn.conflicts,
                               quietly = FALSE,
                               verbose = getOption("verbose"),
                               mask.ok,
                               exclude,
                               include.only,
                               attach.required = missing(include.only)
                               ) {

    if (!missing(package)) {
      package <- package_name(enquo(package), character.only = character.only)

      conflicts_reset()
      on.exit(conflicts_register())
      on_detach(package, function() conflicts_remove(package))

      library(
        package,
        pos = pos,
        lib.loc = lib.loc,
        character.only = TRUE,
        logical.return = logical.return,
        warn.conflicts = FALSE,
        quietly = quietly,
        verbose = verbose,
        mask.ok = mask.ok,
        exclude = exclude,
        include.only = include.only,
        attach.required = attach.required
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
} else {
  shim_library_3_6 <- function(...) {}
}

# require -----------------------------------------------------------------

shim_require_3_1 <- function(package,
                             lib.loc = NULL,
                             quietly = FALSE,
                             warn.conflicts = TRUE,
                             character.only = FALSE) {

  package <- package_name(enquo(package), character.only = character.only)

  conflicts_reset()
  on.exit(conflicts_register())
  on_detach(package, function() conflicts_remove(package))

  require(
    package,
    lib.loc = lib.loc,
    quietly = quietly,
    warn.conflicts = FALSE,
    character.only = TRUE
  )
}

if (getRversion() >= "3.6.0") {
  shim_require_3_6 <- function(package,
                               lib.loc = NULL,
                               quietly = FALSE,
                               warn.conflicts,
                               character.only = FALSE,
                               mask.ok,
                               exclude,
                               include.only,
                               attach.required = missing(include.only)
                               ) {

    package <- package_name(enquo(package), character.only = character.only)

    conflicts_reset()
    on.exit(conflicts_register())
    on_detach(package, function() conflicts_remove(package))

    require(
      package,
      lib.loc = lib.loc,
      quietly = quietly,
      warn.conflicts = FALSE,
      character.only = TRUE,
      mask.ok = mask.ok,
      exclude = exclude,
      include.only = include.only,
      attach.required = attach.required
    )
  }
} else {
  shim_require_3_6 <- function(...) {}
}

# Helpers -----------------------------------------------------------------

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
