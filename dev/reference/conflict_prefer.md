# Persistently prefer one function over another

`conflict_prefer()` allows you to declare "winners" of conflicts. You
can either declare a specific pairing (i.e.
[`dplyr::filter()`](https://dplyr.tidyverse.org/reference/filter.html)
beats `base::filter()`), or an overall winner (i.e.
[`dplyr::filter()`](https://dplyr.tidyverse.org/reference/filter.html)
beats all comers). As of conflicted 1.2.0, in most case you should use
[`conflicts_prefer()`](https://conflicted.r-lib.org/dev/reference/conflicts_prefer.md)
instead as it's both faster and easier to use.

Use `conflicted_prefer_all()` to prefer all functions in a package, or
`conflicted_prefer_matching()` to prefer functions that match a regular
expression.

## Usage

``` r
conflict_prefer(name, winner, losers = NULL, quiet = FALSE)

conflict_prefer_matching(pattern, winner, losers = NULL, quiet = FALSE)

conflict_prefer_all(winner, losers = NULL, quiet = FALSE)
```

## Arguments

- name:

  Name of function.

- winner:

  Name of package that should win the conflict.

- losers:

  Optional vector of packages that should lose the conflict. If omitted,
  `winner` will beat all comers.

- quiet:

  If `TRUE`, all output will be suppressed

- pattern:

  Regular expression used to select objects from the `winner` package.

## Examples

``` r
# Prefer over all other packages
conflict_prefer("filter", "dplyr")
#> [conflicted] Will prefer dplyr::filter over any other package.

# Prefer over specified package or packages
conflict_prefer("filter", "dplyr", "base")
#> [conflicted] Removing existing preference.
#> [conflicted] Will prefer dplyr::filter over base::filter.
conflict_prefer("filter", "dplyr", c("base", "filtration"))
#> [conflicted] Removing existing preference.
#> [conflicted] Will prefer dplyr::filter over base::filter and
#> filtration::filter.

# Prefer many functions that match a pattern
if (FALSE) { # \dontrun{
# Prefer col_* from vroom
conflict_prefer_matching("^col_", "vroom")
} # }
# Or all functions from a package:
if (FALSE) { # \dontrun{
# Prefer all tidylog functions over dtplyr functions
conflict_prefer_all("tidylog", "dtplyr")
} # }
```
