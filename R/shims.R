register_shims <- function() {
  if ("strict_shims" %in% search()) {
    detach("strict_shims")
  }

  strict_shims <- attach(new_environment(), name = "strict_shims")
  register_shim_T_F(strict_shims)
}

register_shim_T_F <- function(env) {
  env_bind_fns(env,
    T = function() abort("Please use TRUE, not T"),
    F = function() abort("Please use FALSE, not F")
  )
}

