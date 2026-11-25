# Find conflicts amongst a set of packages

`conflict_scout()` is the workhorse behind the conflicted package. You
can call it directly yourself if you want to see all conflicts before
hitting them in practice.

## Usage

``` r
conflict_scout(pkgs = NULL)
```

## Arguments

- pkgs:

  Set of packages for which to report conflicts. If `NULL`, the default,
  will report conflicts for all loaded packages

## Value

A named list of character vectors. The names are functions and the
values are the packages where they appear. Disambiguated functions are
removed from that list.

A user friendly print method displays the result as bulleted list.

## Details

For a reexported function, this function will report the package where
the function is defined. If this package is not attached, it will report
the first such package on the search path or in the `pkgs` argument.

## Examples

``` r
conflict_scout()
#> 0 conflicts
```
