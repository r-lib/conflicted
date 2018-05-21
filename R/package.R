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
