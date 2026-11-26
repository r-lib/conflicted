# conflicted: An Alternative Conflict Resolution Strategy

R's default conflict management system gives the most recently loaded
package precedence. This can make it hard to detect conflicts,
particularly when they arise because a package update creates ambiguity
that did not previously exist. 'conflicted' takes a different approach,
making every conflict an error and forcing you to choose which function
to use.

## Resolving conflicts

To permanently resolve a conflict within a session, use
[`conflict_prefer()`](https://conflicted.r-lib.org/dev/reference/conflict_prefer.md):


    library(conflicted)
    library(dplyr)

    conflict_prefer("filter", "dplyr")

## See also

Useful links:

- <https://conflicted.r-lib.org/>

- <https://github.com/r-lib/conflicted>

- Report bugs at <https://github.com/r-lib/conflicted/issues>

## Author

**Maintainer**: Hadley Wickham <hadley@posit.co>

Authors:

- Hadley Wickham <hadley@posit.co>

Other contributors:

- Posit Software, PBC \[copyright holder, funder\]
