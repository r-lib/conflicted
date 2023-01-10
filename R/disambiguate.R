conflict_disambiguate <- function(fun, pkgs, env) {
  if (length(pkgs) == 0) {
    # no conflict, so no action needed
  } else if (length(pkgs) == 1) {
    # No ambiguity, but need to make sure this choice wins, not version
    # from search path (which might be in wrong order)
    env_bind(env, !!fun := getExportedValue(pkgs, fun))
  } else {
    if (is_infix_fun(fun)) {
      env_bind_active(env, !!fun := disambiguate_infix(fun, pkgs))
    } else {
      env_bind_active(env, !!fun := disambiguate_prefix(fun, pkgs))
    }
  }
}

disambiguate_infix <- function(name, pkgs) {
  force(name)
  force(pkgs)

  function(value) {
    if (from_save(sys.calls()))
      return(NULL)

    prefer <- prefer_bullets(pkgs, name)

    cli::cli_abort(c(
      "{label_conflicted()} {.strong {name}} found in {length(pkgs)} packages.",
      "Declare a preference with {.fn conflict_prefer}:",
      prefer
    ))
  }
}

disambiguate_prefix <- function(name, pkgs) {
  force(name)
  force(pkgs)

  function(value) {
    if (from_save(sys.calls()))
      return(NULL)

    bt_name <- backtick(name)

    namespace <- map_chr(pkgs, function(pkg) {
      style_object(pkg, name)
    })
    names(namespace) <- rep("*", length(namespace))
    prefer <- prefer_bullets(pkgs, name)

    cli::cli_abort(c(
      "{label_conflicted()} {.strong {name}} found in {length(pkgs)} packages.",
      "Either pick the one you want with {.code ::}:",
      namespace,
      "Or declare a preference with {.fn conflict_prefer}:",
      prefer
    ))
  }
}

# Helpers -----------------------------------------------------------------

prefer_bullets <- function(pkgs, name) {
  prefer <- map_chr(pkgs, function(pkg) {
  cli::format_inline("{.run [conflict_prefer(\"{name}\", \"{pkg}\")](conflicted::conflict_prefer(\"{name}\", \"{pkg}\"))}")
})
  names(prefer) <- rep("*", length(prefer))
  prefer
}

is_infix_fun <- function(name) {
  base <- c(
    ":", "::", ":::", "$", "@", "^", "*", "/", "+", "-", ">", ">=",
    "<", "<=", "==", "!=", "!", "&", "&&", "|", "||", "~", "<-", "<<-"
  )
  name %in% base || grepl("^%.*%$", name)
}

# This is a hack needed for RStudio, which saves and restores environments
# when you "install and restart", because save() evaluates active bindings.
from_save <- function(calls) {
  is_save <- function(call) {
    is_call(call) && length(call) > 1 && is_symbol(call[[1]], "save")
  }

  for (call in calls) {
    if (is_save(call))
      return(TRUE)
  }

  FALSE
}
