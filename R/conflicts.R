conflicts_find <- function(pkgs = pkgs_attached()) {
  # Ignore any packages loaded by devtools since these contain
  # export all imported functions by default
  is_dev <- vapply(pkgs, pkg_devtools, logical(1))
  pkgs <- pkgs[!is_dev]

  objs <- lapply(pkgs, pkg_ls)
  names(objs) <- pkgs

  index <- invert(objs)
  potential <- Filter(function(x) length(x) > 1, index)

  # Ignore conflicts purely within base packages
  all_base <- vapply(potential, pkgs_base, logical(1))
  potential <- potential[!all_base]

  # Only consider it a conflict if the objects are actually different
  unique <- Map(unique_obj, names(potential), potential)
  conflicts <- Filter(function(x) length(x) > 1, unique)

  conflicts
}

# Resolve conflicts with user preferences
conflicts_prefer <- function(conflicts) {

  # process preferences
  for (fun in ls(prefs)) {
    if (!has_name(conflicts, fun))
      next

    conflicts[[fun]] <- prefs_resolve(fun, conflicts[[fun]])
  }

  conflicts
}

conflicts_detach <- function(pkg) {
  # The detach hook is called before the package is removed from the search path
  conflicts_register(setdiff(pkgs_attached(), pkg))
}

conflicts_register <- function(pkgs = pkgs_attached()) {
  conflicts <- conflicts_find(pkgs)
  conflicts <- conflicts_prefer(conflicts)

  env <- conflicts_init()
  map2(names(conflicts), conflicts, conflict_disambiguate, env = env)

  # Shim library() and require() so we can rebuild
  env_bind(env,
    library = shim_library,
    require = shim_require
  )

  env
}

conflicts_reset <- function() {
  if ("conflicted" %in% search()) {
    detach("conflicted", character.only = TRUE)
  }
}

conflicts_init <- function() {
  conflicts_reset()
  get("attach")(env(), name = "conflicted")
}

conflicts_ls <- function() {
  env_names(scoped_env("conflicted"))
}

unique_obj <- function(name, pkgs) {
  objs <- lapply(pkgs, pkg_get, name)
  names(objs) <- pkgs

  pkgs[!duplicated(objs)]
}

conflict_disambiguate <- function(fun, pkgs, env) {
  if (length(pkgs) == 1) {
    # No ambiguity, but need to make sure this choice wins, not version
    # from search path (which might be in wrong order)
    env_bind(env, !!fun := getExportedValue(pkg, fun))
  } else if (is_infix_fun(fun)) {
    env_bind_fns(env, !!fun := disambiguate_infix(fun, pkgs))
  } else {
    env_bind_fns(env, !!fun := disambiguate_prefix(fun, pkgs))
  }
}

backtick <- function(x) {
  ifelse(x == make.names(x), x, paste0("`", x, "`"))
}

is_infix_fun <- function(name) {
  base <- c(
    ":", "::", ":::", "$", "@", "^", "*", "/", "+", "-", ">", ">=",
    "<", "<=", "==", "!=", "!", "&", "&&", "|", "||", "~", "<-", "<<-"
  )
  name %in% base || grepl("^%.*%$", name)
}
