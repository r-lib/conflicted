# error message is informative

    Code
      disambiguate_prefix("x", c("a", "b", "c"))()
    Error <rlang_error>
      [conflicted] `x` found in 3 packages.
      Either pick the one you want with `::` 
      * a::x
      * b::x
      * c::x
      Or declare a preference with `conflict_prefer()`
      * conflict_prefer("x", "a")
      * conflict_prefer("x", "b")
      * conflict_prefer("x", "c")
    Code
      disambiguate_prefix("if", c("a", "b", "c"))()
    Error <rlang_error>
      [conflicted] `if` found in 3 packages.
      Either pick the one you want with `::` 
      * a::`if`
      * b::`if`
      * c::`if`
      Or declare a preference with `conflict_prefer()`
      * conflict_prefer("if", "a")
      * conflict_prefer("if", "b")
      * conflict_prefer("if", "c")
    Code
      disambiguate_infix("%in%", c("a", "b", "c"))()
    Error <rlang_error>
      [conflicted] `%in%` found in 3 packages.
      Declare a preference with `conflict_prefer()`:
      * conflict_prefer("%in%", "a")
      * conflict_prefer("%in%", "b")
      * conflict_prefer("%in%", "c")

