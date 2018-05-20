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

conflict_fun <- function(name, pkgs) {
  bullets <- paste0(" * ", style_name(pkgs, "::", name))
  msg <- paste0(
    "Multiple definitions found for ", style_name(name), ". ",
    "Please pick one:\n",
    paste0(bullets, collapse = "\n")
  )

  function(...) {
    abort(msg)
  }
}

