remove_conflicts <- function() {
  if ("strict_conflicts" %in% search()) {
    detach("strict_conflicts")
  }
}

register_conflicts <- function() {
  remove_conflicts()

  objs <- lapply(pkgs_attached(), pkg_ls)
  names(objs) <- pkgs_attached()

  # TODO: figure out how to ignore conflicts within base packages
  index <- invert(objs)
  potential <- Filter(function(x) length(x) > 1, index)

  # Only consider it a conflict if the objects are actually different
  unique <- Map(unique_obj, names(potential), potential)
  conflicts <- Filter(function(x) length(x) > 1, unique)

  env <- get("attach")(new_environment(), name = "strict_conflicts")

  # For each conflicted, new active binding in shim environment
  conflict_overrides <- Map(conflict_fun, names(conflicts), conflicts)
  env_bind_fns(env, !!! conflict_overrides)

  # Shim library() and require() so we can rebuild
  env_bind(env,
    library = shim_library,
    require = shim_require
  )
}

unique_obj <- function(name, pkgs) {
  objs <- lapply(pkgs, pkg_get, name)
  names(objs) <- pkgs

  pkgs[!duplicated(objs)]
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

shim_library <- function(package, help, pos = 2, lib.loc = NULL, character.only = FALSE,
    logical.return = FALSE, warn.conflicts = TRUE, quietly = FALSE,
    verbose = getOption("verbose")) {

  package <- package_name(enquo(package), character.only = character.only)
  on.exit(register_conflicts())

  lax(library(
    package,
    help = help,
    pos = pos,
    lib.loc = lib.loc,
    character.only = TRUE,
    logical.return = logical.return,
    warn.conflicts = FALSE,
    quietly = quietly,
    verbose = verbose
  ))
}

shim_require <- function(package, lib.loc = NULL, quietly = FALSE, warn.conflicts = TRUE,
                        character.only = FALSE) {

  package <- package_name(enquo(package), character.only = character.only)
  on.exit(register_conflicts())

  lax(require(
    package,
    lib.loc = lib.loc,
    quietly = quietly,
    warn.conflicts = FALSE,
    character.only = TRUE
  ))

}

conflict_fun <- function(name, pkgs) {
  bullets <- paste0(" * ", pkgs, "::", name)

  function(...) {
    strict_abort(
      "Multiple definitions found for `", name, "`.\n",
      "Please pick one:\n",
      paste0(bullets, collapse = "\n")
    )
  }
}


