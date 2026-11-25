conflicts_register <- function(pkgs = pkgs_attached()) {
  conflicts <- conflicts_find(pkgs)

  env <- conflicts_init()
  map2(names(conflicts), conflicts, conflict_disambiguate, env = env)

  # Shim library() and require() so we can rebuild
  shims_bind(env)

  conflicts_register_startup_hooks()

  env
}

conflicts_register_if_needed <- function(package) {
  if (pkg_attached(package)) {
    conflicts_register()
  }
  invisible()
}

conflicts_remove <- function(pkg) {
  # The detach hook is called before the package is removed from the search path
  conflicts_register(setdiff(pkgs_attached(), pkg))
}

# Startup uses base::require(), which bypasses our shims. Rebuild as each
# remaining default package attaches, since one may fail to load or attach
# early as a dependency of another package.
startup_hooks <- env()

conflicts_register_startup_hooks <- function() {
  pending <- setdiff(getOption("defaultPackages"), .packages())
  for (pkg in setdiff(pending, env_names(startup_hooks))) {
    hook <- packageEvent(pkg, "attach")
    setHook(hook, conflicts_refresh_startup)
    startup_hooks[[pkg]] <- hook
  }
}

conflicts_refresh_startup <- function(pkg, ...) {
  conflicts_remove_startup_hooks(pkg)
  if (conflicts_attached()) {
    conflicts_register()
  }
}

conflicts_remove_startup_hooks <- function(pkgs = env_names(startup_hooks)) {
  for (pkg in intersect(pkgs, env_names(startup_hooks))) {
    hook <- startup_hooks[[pkg]]
    remaining <- Filter(
      function(x) !identical(x, conflicts_refresh_startup),
      getHook(hook)
    )
    setHook(hook, remaining, action = "replace")
    env_unbind(startup_hooks, pkg)
  }
}

# Environment management -------------------------------------------------

conflicts_init <- function() {
  conflicts_reset()
  get("attach")(env(), name = ".conflicts")
}

conflicts_attached <- function() {
  ".conflicts" %in% search()
}

conflicts_reset <- function() {
  if (conflicts_attached()) {
    detach(".conflicts", character.only = TRUE)
  }
}
