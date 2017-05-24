
<!-- README.md is generated from README.Rmd. Please edit that file -->
strict
======

[![Travis-CI Build Status](https://travis-ci.org/hadley/strict.svg?branch=master)](https://travis-ci.org/hadley/strict) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/strict)](https://cran.r-project.org/package=strict)

The goal of strict to make R behave a little more strictly, making base functions more likely to throw an error rather than returning potentially ambiguous results.

`library(strict)` forces you to confront potential problems now, instead of in the future. This has both pros and cons: often you can most easily fix a potential ambiguity when your working on the code (rather than in six months time when you've forgotten how it works), but it also forces you to resolve ambiguities that might never occur with your code/data.

Installation
------------

``` r
# install.packages("devtols")
devtools::install_github("hadley/strict")
```

Features
--------

-   An alternative conflict resolution mechansim. Instead of warning about conflicts on package load and letting the last loaded package win, strict throws an error when you access ambiguous functions:

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

    (Thanks to @krlmlr for this neat idea!)

-   Shims for functions with "risky" arguments, i.e. arguments that either rely on global options (like `stringsAsFactors`) or have computed defaults that 90% evaluate to one thing (like `drop`). strict forces you to supply values for these arguments.

    ``` r
    library(strict)
    mtcars[, 1]
    #> Error: [strict]
    #> Please supply a value for `drop` argument.
    #> Please see ?strict_arg for more details

    data.frame(x = "a")
    #> Error: [strict]
    #> Please supply a value for `stringsAsFactors` argument.
    #> Please see ?strict_arg for more details
    ```

-   Automatically sets options to warn when partial matching occurs.

    ``` r
    library(strict)

    df <- data.frame(xyz = 1, stringsAsFactors = FALSE)
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
