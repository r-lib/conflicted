# conflicted 0.1.0.9000

* Deprecated functions (i.e. functions with a call to `.Deprecated()` as the
  first element of the function body) now never generate conflicts.

* conflicts now expects packages that override functions in base packages 
  to obey the "superset principle", i.e. that `foo::bar(...)` must return
  the same value of `base::bar(...)` whenever the input is not an error.
  In other words, if you override a base function you can only extend the API,
  not change or reduce it.
  
    Two notable functions that fail to implement the superset principle are
    `dplyr::filter()` and `dplyr::lag()`, and these are special cases to ensure
    that they generate a conflict (#2).

* `conflicts_find()` reports on all conflicts found amongst a set of 
  packages.

* `conflicts_prefer()` allows you to declare a persistent preference 
  (within a session) for one function over another (#4)

* Added a `NEWS.md` file to track changes to the package.

* conflicted now listens for `detach()` events and removes conflicts that
  are removed by detaching a package (#5)

* Error messages for infix functions and non-syntactic function names are
  improved (#14)
  
* conflicted is around 5x faster. I benchmarked by loading ~170 packages
  (as many as I can load without running out of DLLs), and registering 
  conflicts only took ~100 ms (#6).
