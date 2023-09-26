pkg_dep <- function(pkg) {
  if (pkg == "base") {
    return()
  }
  ns <- asNamespace(pkg)
  path <- ns$.__NAMESPACE__.$path

  # Safety net
  if (is.null(path)) {
    lib <- NULL
  } else {
    lib <- dirname(path)
  }

  imports <- utils::packageDescription(pkg, lib.loc = lib)$Imports
  if (is.null(imports)) {
    return(character())
  }
  imports <- gsub(" *", "", imports)
  imports <- gsub("[(][^)]+[)]", "", imports)
  imports <- gsub("\n", "", imports)
  strsplit(imports, ",")[[1]]
}

pkg_deps <- function(pkgs) {
  lapply(set_names(pkgs), pkg_dep)
}

# AI generated
topo_sort <- function(pkgs) {
  adj_list <- pkg_deps(pkgs)
  visited <- list()
  stack <- character()

  dfs <- function(vertex) {
    visited[[vertex]] <<- TRUE

    for (neighbor in adj_list[[vertex]]) {
      if (!isTRUE(visited[[neighbor]])) {
        dfs(neighbor)
      }
    }

    stack <<- c(stack, vertex)
  }

  for (vertex in names(adj_list)) {
    if (!isTRUE(visited[[vertex]])) {
      dfs(vertex)
    }
  }

  intersect(stack, pkgs)
}
