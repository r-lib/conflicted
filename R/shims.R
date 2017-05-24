register_shims <- function() {
  if ("strict_shims" %in% search()) {
    detach("strict_shims")
  }

  strict_shims <- attach(new_environment(), name = "strict_shims")
  register_shim_T_F(strict_shims)

  # What's getting overriden
  shims <- ls(strict_shims)
  message("Adding stict shims for: ", paste(shims, collapse = ", "))
}

register_shim_T_F <- function(env) {
  env_bind_fns(env,
    T = function() abort("[strict] Please use TRUE, not T"),
    F = function() abort("[strict] Please use FALSE, not F")
  )
}
