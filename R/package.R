pkgs_attached <- function() {
  gsub("package:", "", grep("package:", search(), value = TRUE))
}

pkg_attached <- function(x) {
  paste0("package:", x) %in% search()
}

pkg_ls <- function(x) {
  ns <- ns_env(x)
  exports <- getNamespaceExports(ns)

  intersect(exports, env_names(ns))
}

# Not currently used because pkg_get() can't find it, and it seems unlikely
# to be a common source of conflicts
pkg_data <- function(x) {
  ns <- ns_env(x)
  lazy_data <- .getNamespaceInfo(ns, "lazydata")

  if (is.null(lazy_data))
    return(character())

  env_names(lazy_data)
}

pkg_get <- function(pkg, name) {
  get(name, envir = ns_env(pkg), inherits = FALSE)
}

base_packages <- c(
  "KernSmooth", "MASS", "Matrix", "base", "boot", "class", "cluster",
  "codetools", "compiler", "datasets", "foreign", "grDevices",
  "graphics", "grid", "lattice", "methods", "mgcv", "nlme", "nnet",
  "parallel", "rlanglibtest", "rpart", "spatial", "splines", "stats",
  "stats4", "survival", "tcltk", "tools", "translations", "utils"
)

pkgs_base <- function(x) {
  all(x %in% base_packages)
}

