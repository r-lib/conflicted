# Changelog

## conflicted (development version)

- [`conflict_scout()`](https://conflicted.r-lib.org/dev/reference/conflict_scout.md)
  refers to the package where the function was defined, for reexported
  functions ([\#93](https://github.com/r-lib/conflicted/issues/93)).

- [`conflict_scout()`](https://conflicted.r-lib.org/dev/reference/conflict_scout.md)
  no longer returns functions whose conflicts have been resolved
  manually or automatically
  ([\#95](https://github.com/r-lib/conflicted/issues/95)).

## conflicted 1.2.0

CRAN release: 2023-02-01

- New
  [`conflicts_prefer()`](https://conflicted.r-lib.org/dev/reference/conflicts_prefer.md)
  to easily declare multiple preferences at once:
  `conflicts_prefer(dplyr::filter, lubridate::week, ...)`
  ([\#82](https://github.com/r-lib/conflicted/issues/82)).

- Disambiguation message now provides clickable preferences
  ([\#74](https://github.com/r-lib/conflicted/issues/74)).

- Conflicts now take into account the `include.only` and `exclude`
  arguments that you might have specified in
  [`library()`](https://rdrr.io/r/base/library.html)
  ([\#84](https://github.com/r-lib/conflicted/issues/84)).

- [`conflict_prefer_all()`](https://conflicted.r-lib.org/dev/reference/conflict_prefer.md)
  and
  [`conflict_prefer_matching()`](https://conflicted.r-lib.org/dev/reference/conflict_prefer.md)
  are now much faster. And when `losers` is supplied, they only register
  the minimal necessary number of conflicts.

## conflicted 1.1.0

CRAN release: 2021-11-26

- New `conflicted_prefer_all()` and `conflicted_prefer_matching()` to
  prefer functions en masse
  ([\#51](https://github.com/r-lib/conflicted/issues/51)).

- Improvements to conflict detection and resolution:

  - Reports conflicts involving lazy loaded datasets
    ([\#54](https://github.com/r-lib/conflicted/issues/54)).

  - Don’t report conflicts involving a `standardGeneric`
    ([\#47](https://github.com/r-lib/conflicted/issues/47)).

  - Better handling of conflicts cleared by superset principle: if there
    is a conflict all functions (including any base functions) are
    reported, and if there isn’t a conflict, no packages are reported
    (instead of 1)
    ([\#47](https://github.com/r-lib/conflicted/issues/47)).

  - Don’t report conflict between a function and a non-function
    ([\#30](https://github.com/r-lib/conflicted/issues/30)).

  - Conflicts involving a primitive function no longer error
    ([@nerskin](https://github.com/nerskin),
    [\#46](https://github.com/r-lib/conflicted/issues/46),
    [\#48](https://github.com/r-lib/conflicted/issues/48)).

## conflicted 1.0.4

CRAN release: 2019-06-21

- Fixes for dev rlang

## conflicted 1.0.3

CRAN release: 2019-05-01

- Fix \> vs \>= mistake

## conflicted 1.0.2

CRAN release: 2019-03-29

- Align with changes to R 3.6

## conflicted 1.0.1

CRAN release: 2018-10-02

- Internal `has_moved()` function no longer fails when it encounters a
  call to [`.Deprecated()`](https://rdrr.io/r/base/Deprecated.html) with
  no arguments ([\#29](https://github.com/r-lib/conflicted/issues/29)).

- `.conflicts` environment is correctly removed and replaced each time a
  new package is loaded
  ([\#28](https://github.com/r-lib/conflicted/issues/28)).

## conflicted 1.0.0

CRAN release: 2018-09-15

#### New functions

- [`conflict_scout()`](https://conflicted.r-lib.org/dev/reference/conflict_scout.md)
  reports all conflicts found with a set of packages.

- [`conflict_prefer()`](https://conflicted.r-lib.org/dev/reference/conflict_prefer.md)
  allows you to declare a persistent preference (within a session) for
  one function over another
  ([\#4](https://github.com/r-lib/conflicted/issues/4)).

#### Improve conflict resolution

- conflicts now generally expects packages that override functions in
  base packages to obey the “superset principle”, i.e. that
  `foo::bar(...)` must return the same value of `base::bar(...)`
  whenever the input is not an error. In other words, if you override a
  base function you can only extend the API, not change or reduce it.

  There are two exceptions. If the arguments of the two functions are
  not compatible (i.e. the function in the package doesn’t include all
  arguments of the base package), conflicts can tell it doesn’t follow
  the superset principle. Additionally,
  [`dplyr::lag()`](https://dplyr.tidyverse.org/reference/lead-lag.html)
  fails to follow the superset principle, and is marked as a special
  case ([\#2](https://github.com/r-lib/conflicted/issues/2)).

- Functions that have moved between packages (i.e. functions with a call
  to `.Deprecated("pkg::foo")`) as the first element of the function
  body) will never generate conflicts.

- conflicted now listens for
  [`detach()`](https://rdrr.io/r/base/detach.html) events and removes
  conflicts that are removed by detaching a package
  ([\#5](https://github.com/r-lib/conflicted/issues/5))

### Minor improvements and bug fixes

- Error messages for infix functions and non-syntactic function names
  are improved ([\#14](https://github.com/r-lib/conflicted/issues/14))
