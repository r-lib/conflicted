
<!-- README.md is generated from README.Rmd. Please edit that file -->
strict
======

[![Travis-CI Build Status](https://travis-ci.org/hadley/strict.svg?branch=master)](https://travis-ci.org/hadley/strict) [![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/strict)](https://cran.r-project.org/package=strict) [![Coverage Status](https://img.shields.io/codecov/c/github/hadley/strict/master.svg)](https://codecov.io/github/hadley/strict?branch=master)

The goal of strict to make R behave a little more strictly, making base functions more likely to throw an error rather than returning potentially ambiguous results.

`library(strict)` forces you to confront potential problems now, instead of in the future. This has both pros and cons: often you can most easily fix a potential ambiguity when your working on the code (rather than in six months time when you've forgotten how it works), but it also forces you to resolve ambiguities that might never occur with your code/data.

Installation
------------

``` r
# install.packages("devtools")
devtools::install_github("hadley/strict")
```

Features
--------

`library(strict)` affects code in the current script/session only (i.e. it doesn't affect code in others packages).

-   An alternative conflict resolution mechanism. Instead of warning about conflicts on package load and letting the last loaded package win, strict throws an error when you access ambiguous functions:

    ``` r
    library(strict)
    library(plyr)
    library(Hmisc)
    #> Loading required package: lattice
    #> Loading required package: survival
    #> Loading required package: Formula
    #> Loading required package: ggplot2

    is.discrete
    #> Error: [strict]
    #> Multiple definitions found for `is.discrete`.
    #> Please pick one:
    #>  * Hmisc::is.discrete
    #>  * plyr::is.discrete
    ```

    (Thanks to @[krlmlr](https://github.com/krlmlr) for this neat idea!)

-   Shims for functions with "risky" arguments, i.e. arguments that either rely on global options (like `stringsAsFactors`) or have computed defaults that 90% evaluate to one thing (like `drop`). strict forces you to supply values for these arguments.

    ``` r
    library(strict)
    mtcars[, 1]
    #> Error: [strict]
    #> Please explicitly specify `drop` when selecting a single column
    #> Please see ?strict_drop for more details

    data.frame(x = "a")
    #> Error: [strict]
    #> Please supply a value for `stringsAsFactors` argument.
    #> Please see ?strict_arg for more details
    ```

-   Automatically sets options to warn when partial matching occurs.

    ``` r
    library(strict)

    df <- data.frame(xyz = 1)
    df$x
    #> Warning in `$.data.frame`(df, x): Partial match of 'x' to 'xyz' in data
    #> frame
    #> [1] 1
    ```

-   `T` and `F` generate errors, forcing you to use `TRUE` and `FALSE`.

    ``` r
    library(strict)
    T
    #> Error: [strict]
    #> Please use TRUE, not T
    ```

-   `sapply()` throws an error suggesting that you use the type-safe `vapply()` instead. `apply()` throws an error if you use it with a data frame.

    ``` r
    library(strict)
    sapply(1:10, sum)
    #> Error: [strict]
    #> Please use `vapply()` instead of `sapply()`.
    #> Please see ?strict_sapply for more details
    ```

-   `:` will throw an error instead of creating a decreasing sequence that terminates in 0.

    ``` r
    library(strict)

    x <- numeric()
    1:length(x)
    #> Error: [strict]
    #> Tried to create descending sequence 1:0. Do you want to `seq_along()` instead?
    #> 
    #> Please see ?shim_colon for more details
    ```

-   `diag()` and `sample()` throw an error if given scalar `x`. This avoids an otherwise unpleasant surprise.

    ``` r
    library(strict)

    sample(5:3)
    #> [1] 5 4 3
    sample(5:4)
    #> [1] 5 4
    lax(sample(5:5))
    #> [1] 3 2 1 4 5

    sample(5:5)
    #> Error: [strict]
    #> `sample()` has surprising behaviour when `x` is a scalar.
    #> Use `sample.int()` instead.
    #> Please see ?strict_sample for more details
    ```

Once strict is loaded, you can continue to run code in a lax manner using `lax()`.
