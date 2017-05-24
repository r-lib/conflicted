remove_shims <- function() {
  if ("strict_shims" %in% search()) {
    detach("strict_shims")
  }
}

register_shims <- function() {
  remove_shims()

  strict_shims <- get("attach")(new_environment(), name = "strict_shims")
  strict_shims$`:` <- shim_colon

  register_shim_T_F(strict_shims)
  register_shims_apply(strict_shims)
  register_risky_shims(strict_shims)
}

register_shim_T_F <- function(env) {
  env_bind_fns(env,
    T = function() strict_abort("Please use TRUE, not T"),
    F = function() strict_abort("Please use FALSE, not F")
  )
}
