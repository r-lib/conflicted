pkgs_attached <- function() {
  gsub("package:", "", grep("package:", search(), value = TRUE))
}

pkg_env <- function(x) {
  as.environment(paste0("package:", x))
}

pkg_ls <- function(x) {
  ls(envir = pkg_env(x))
}

pkg_funs <- function(x) {
  env <- pkg_env(x)
  objs <- mget(ls(envir = env), envir = env, inherits = FALSE)
  Filter(function(x) is_function(x) && !is_primitive(x), objs)
}
