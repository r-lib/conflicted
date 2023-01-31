pkgs_attached <- function() {
  pkgs <- gsub("package:", "", grep("package:", search(), value = TRUE))

  # Ignore any packages loaded by devtools since these contain
  # export all imported functions by default
  is_dev <- vapply(pkgs, pkg_devtools, logical(1))
  pkgs[!is_dev]
}

pkg_attached <- function(x) {
  paste0("package:", x) %in% search()
}

# Use attached package if possible, because that is affected by the
# `exclude` and `include.only` arguments to library(). Otherwise fall back
# to a NAMESPACE based approach
pkg_ls <- function(pkg) {
  if (pkg_attached(pkg)) {
    ls(pkg_env_name(pkg))
  } else {
    ns <- getNamespace(pkg)
    exports <- getNamespaceExports(ns)

    names <- intersect(exports, env_names(ns))
    int <- grepl("^.__", names)
    c(names[!int], pkg_data(pkg))
  }
}

pkg_data <- function(x) {
  ns <- ns_env(x)
  lazy_data <- .getNamespaceInfo(ns, "lazydata")

  if (is.null(lazy_data))
    return(character())

  env_names(lazy_data)
}

base_packages <- c(
  "base", "datasets", "grDevices", "graphics", "methods", "stats", "utils"
)

pkgs_base <- function(x) {
  all(x %in% base_packages)
}

