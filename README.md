# strict

[![Travis-CI Build Status](https://travis-ci.org/hadley/strict.svg?branch=master)](https://travis-ci.org/hadley/strict)

The goal of strict to make R behave a little more strictly, making base functions more likely to throw an error rather than returning potentially ambiguous results. 

`library(strict)` forces you to confront potential problems now, instead of in the future. This has both pros and cons: often you can most easily fix a potential ambiguity when your working on the code (rather than in six months time when you've forgotten how it works), but it also forces you to resolve ambiguities that might never occur with your code/data.

## Installation

```R
# install.packages("devtols")
devtools::install_github("hadley/strict")
```

## Features

*   An alternative conflict resolution mechansim. Instead of warning about 
    conflicts on package load and letting the last loaded package win,
    strict throws an error when you access ambiguous functions:
  
    ```R
    library(strict)
    library(plyr)
    library(Hmisc)
    
    is.discrete
    #> Error: [strict] Multiple definitions found for `is.discrete`:
    #> * Hmisc::is.discrete
    #> * plyr::is.discrete 
    ```

*   Shims for functions with "risky" arguments, i.e. arguments that either rely
    on global options (like `stringsAsFactors`) or have computed defaults that
    90% evaluate to one thing (like `drop`). strict forces you to supply values
    for these arguments.
    
    ```R
    library(strict)
    mtcars[, 1]
    #> Error: Must supply a value for `drop` argument
    #> Please see ?strict_arg for more details 
    
    data.frame(x = "a")
    #> Error: Must supply a value for `stringsAsFactors` argument
    #> Please see ?strict_arg for more details 
    ```

*   Automatically sets options to warn when partial matching occurs.

*   `T` and `F` generate errors, forcing you to use `TRUE` and `FALSE`.

*   `sapply()` throws an error suggesting that you use the type-safe
    `vapply()` instead. `apply()` throws an error if you use it with a 
    data frame.

