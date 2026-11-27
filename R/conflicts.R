conflicts_register <- function(pkgs = pkgs_attached()) {
  conflicts <- conflict_scout(pkgs)

  env <- conflicts_init()
  map2(names(conflicts), conflicts, conflict_disambiguate, env = env)

  # Shim library() and require() so we can rebuild
  shims_bind(env)

  conflicts_register_detach(pkgs)

  env
}

detach_hooks <- env()

conflicts_register_detach <- function(pkgs) {
  pkgs <- setdiff(pkgs, "base")
  for (pkg in pkgs) {
    if (!pkg_attached(pkg) || env_has(detach_hooks, pkg)) {
      next
    }
    conflict_detach_register(pkg)
  }
}

conflict_detach_register <- function(pkg) {
  force(pkg)
  env_bind(detach_hooks, !!pkg := TRUE)
  on_detach(pkg, function() {
    env_unbind(detach_hooks, pkg)
    if (conflicts_attached()) {
      conflicts_remove(pkg)
    }
  })
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
