# Declare many preferences at once

`conflicts_prefer()` allows you to declare "winners" of conflicts,
declaring one or many winners at once.

See
[`conflict_prefer()`](https://conflicted.r-lib.org/dev/reference/conflict_prefer.md)
for more precise control.

## Usage

``` r
conflicts_prefer(..., .quiet = FALSE)
```

## Arguments

- ...:

  Functions to prefer in form `pkg::fun` or `pkg::fun()`.

- .quiet:

  If `TRUE`, all output will be suppressed

## Best practices

I recommend placing a single call to `conflicts_prefer()` at the top of
your script, immediately after loading all needed packages with calls to
[`library()`](https://rdrr.io/r/base/library.html).

## Examples

``` r
conflicts_prefer(
  dplyr::filter(),
  dplyr::lag(),
)
#> [conflicted] Removing existing preference.
#> [conflicted] Will prefer dplyr::filter over any other package.
#> [conflicted] Will prefer dplyr::lag over any other package.

# or
conflicts_prefer(
  dplyr::filter,
  dplyr::lag,
)
#> [conflicted] Removing existing preference.
#> [conflicted] Will prefer dplyr::filter over any other package.
#> [conflicted] Removing existing preference.
#> [conflicted] Will prefer dplyr::lag over any other package.
```
