conflicts_register <- function(pkgs = pkgs_attached()) {
  conflicts <- conflict_scout(pkgs)

  env <- conflicts_init()
  map2(names(conflicts), conflicts, conflict_disambiguate, env = env)

  # Shim library() and require() so we can rebuild
  shims_bind(env)

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
