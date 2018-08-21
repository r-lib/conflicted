# conflicted 0.1.0.9000

* Added a `NEWS.md` file to track changes to the package.

* conflicted now listens for `detach()` events and removes conflicts that
  are removed by detaching a package (#5)

* Error messages for infix functions and non-syntactic function names are
  improved (#14)
  
* conflicted is around 5x faster. I benchmarked by loading ~170 packages
  (as many as I can load without running out of DLLs), and registering 
  conflicts only took ~100 ms (#6).
