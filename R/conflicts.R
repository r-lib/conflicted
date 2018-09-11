conflicts_register <- function(pkgs = pkgs_attached()) {
  conflicts <- conflict_scout(pkgs)

  env <- conflicts_init()
  map2(names(conflicts), conflicts, conflict_disambiguate, env = env)

  # Shim library() and require() so we can rebuild
  env_bind(env,
    library = shim_library,
    require = shim_require
  )

  env
}

conflicts_remove <- function(pkg) {
  # The detach hook is called before the package is removed from the search path
  conflicts_register(setdiff(pkgs_attached(), pkg))
}

# Environment manageament -------------------------------------------------

conflicts_init <- function() {
  conflicts_reset()
  get("attach")(env(), name = ".conflicts")
}

conflicts_reset <- function() {
  if ("conflicted" %in% search()) {
    detach("conflicted", character.only = TRUE)
  }
}

conflicts_ls <- function() {
  env_names(scoped_env("conflicted"))
}
