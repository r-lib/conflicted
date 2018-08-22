disambiguate_infix <- function(name, pkgs) {
  force(name)
  force(pkgs)

  function(value) {
    bullets <- paste0("* conflict_prefer(\"", name, "\", \"", pkgs, "\")")
    msg <- paste0(
      "[conflicted] ", style_name("`", name, "`"), " found in ", length(pkgs), " packages.\n",
      "Declare a preference with `conflicted_prefer()`:\n",
      paste0(bullets, collapse = "\n")
    )
    abort(msg)
  }
}

disambiguate_prefix <- function(name, pkgs) {
  force(name)
  force(pkgs)

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
