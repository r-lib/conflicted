#' Declare many conflict preferences at once
#'
#' [conflict_prefer()] and friends register conflicts after each call. If you
#' are registering many conflicts this can be expensive
#'
#' @param code A block of code that declares preferences.
#' @export
#' @examples
#' conflicts_declare({
#'   conflict_prefer("filter", "dplyr")
#'   conflict_prefer_all("dplyr", "MASS")
#' })
conflicts_declare <- function(code) {
  old <- env_poke(the, "pause_registration", TRUE)

  on.exit({
    env_poke(the, "pause_registration", old)
    conflicts_register()
  })

  code
}
conflicts_register <- function(pkgs = pkgs_attached()) {
  if (the$pause_registration) {
    return()
  }

  conflicts <- conflict_scout(pkgs)

  env <- conflicts_init()
  map2(names(conflicts), conflicts, conflict_disambiguate, env = env)

  # Shim library() and require() so we can rebuild
  shims_bind(env)

  env
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
