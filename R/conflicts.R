conflicts_register <- function(pkgs = pkgs_attached()) {
  conflicts <- conflicts_find(pkgs)

  env <- conflicts_init()
  map2(names(conflicts), conflicts, conflict_disambiguate, env = env)

  # Shim library() and require() so we can rebuild
  env_bind(env,
    library = shim_library,
    require = shim_require
  )

  env
}

conflicts_find <- function(pkgs = pkgs_attached()) {
  objs <- lapply(pkgs, pkg_ls)
  names(objs) <- pkgs

  index <- invert(objs)
  potential <- Filter(function(x) length(x) > 1, index)

  # Only consider it a conflict if the objects are actually different
  unique <- Map(unique_obj, names(potential), potential)
  conflicts <- Filter(function(x) length(x) > 1, unique)

  # superset principle: ignore single conflict with base packages
  # unless attr(f, "conflicted_superset") is FALSE
  conflicts <- map2(names(conflicts), conflicts, superset_principle)

  # apply declared user preferences
  for (fun in ls(prefs)) {
    if (!has_name(conflicts, fun))
      next

    conflicts[[fun]] <- prefs_resolve(fun, conflicts[[fun]])
  }

  conflicts
}

superset_principle <- function(fun, pkgs) {
  non_base <- setdiff(pkgs, base_packages)
  if (length(non_base) == 0) {
    # all base, so no conflicts
    character()
  } else if (length(non_base) == 1) {
    # only one, so assume it obeys superset principle
    if (not_superset(fun, non_base)) {
      pkgs
    } else {
      non_base
    }
  } else {
    non_base
  }
}

not_superset <- function(fun, pkg) {
  pkg == "dplyr" && fun %in% c("lag", "filter")
}

conflicts_remove <- function(pkg) {
  # The detach hook is called before the package is removed from the search path
  conflicts_register(setdiff(pkgs_attached(), pkg))
}

# Environment manageament -------------------------------------------------

conflicts_init <- function() {
  conflicts_reset()
  get("attach")(env(), name = "conflicted")
}

conflicts_reset <- function() {
  if ("conflicted" %in% search()) {
    detach("conflicted", character.only = TRUE)
  }
}

conflicts_ls <- function() {
  env_names(scoped_env("conflicted"))
}
