
<!-- README.md is generated from README.Rmd. Please edit that file -->

# conflicted

The goal of conflicted is to provide an alternative conflict resolution
strategy. R’s default conflict resolution system gives precedence to the
most recently loaded package. This can make it hard to detect conflicts,
particularly when introduced by an update to an existing package.
conflicted takes a different approach, making every conflict an error
and forcing you to choose which function to use.

## Installation

``` r
# install.packages("devtools")
devtools::install_github("r-lib/conflicted")
```

## Usage

To active conflicted, all you need to do is load it:

``` r
library(conflicted)
library(dplyr)

filter
#> Error: [strict]
#> Multiple definitions found for `filter`.
#> Please pick one:
#>  * dplyr::filter
#>  * stats::filter
```

(Thanks to @[krlmlr](https://github.com/krlmlr) for this neat idea\!)
