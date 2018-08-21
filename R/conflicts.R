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

conflicts_detach <- function(pkg) {
  # The detach hook is called before the package is removed from the search path
  conflicts_register(setdiff(pkgs_attached(), pkg))
}

conflicts_register <- function(pkgs = pkgs_attached()) {
  env <- conflicts_init()
  conflicts <- conflicts_find(pkgs)

  # process preferences
  for (fun in ls(prefs)) {
    if (!has_name(conflicts, fun))
      next
    if (!prefs_resolved(fun, conflicts[[fun]]))
      next

    # bind winner & remove from conflicts
    pkg <- prefs[[fun]][[1]]
    env_bind(env, !!fun := getExportedValue(pkg, fun))
    conflicts[[fun]] <- NULL
  }

  # For each conflict, create new active binding
  conflict_overrides <- Map(conflict_binding, names(conflicts), conflicts)
  env_bind_fns(env, !!!conflict_overrides)

  # Shim library() and require() so we can rebuild
  env_bind(env,
    library = shim_library,
    require = shim_require
  )
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

unique_obj <- function(name, pkgs) {
  objs <- lapply(pkgs, pkg_get, name)
  names(objs) <- pkgs

  pkgs[!duplicated(objs)]
}

conflict_binding <- function(name, pkgs) {
  force(name)
  force(pkgs)

  if (is_infix_fun(name)) {
    function(value) {
      bullets <- paste0("* conflict_prefer(\"", name, "\", \"", pkgs, "\")")
      msg <- paste0(
        "[conflicted] ", style_name("`", name, "`"), " found in ", length(pkgs), " packages.\n",
        "Declare a preference with `conflicted_prefer()`:\n",
        paste0(bullets, collapse = "\n")
      )
      abort(msg)

    }
  } else {
    function(value) {
      bt_name <- backtick(name)
      bullets_temp <- paste0("* ", style_name(pkgs, "::", bt_name))
      bullets_pers <- paste0("* ", "conflict_prefer(\"", name, "\", \"", pkgs, "\")")

      msg <- paste0(
        "[conflicted] ", style_name("`", name, "`"), " found in ", length(pkgs), " packages.\n",
        "Either pick the one you want with `::` \n",
        paste0(bullets_temp, collapse = "\n"), "\n",
        "Or declare a preference with `conflicted_prefer()`\n",
        paste0(bullets_pers, collapse = "\n")
      )
      abort(msg)
    }
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
