pkgs_attached <- function() {
  gsub("package:", "", grep("package:", search(), value = TRUE))
}

pkg_env <- function(x) {
  as.environment(paste0("package:", x))
}

pkg_ls <- function(x) {
  ls(envir = pkg_env(x))
}

pkg_get <- function(pkg, name) {
  get(name, envir = pkg_env(pkg))
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

