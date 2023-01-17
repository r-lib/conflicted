# error message is informative

    Code
      disambiguate_prefix("x", c("a", "b", "c"))()
    Condition
      Error:
      ! [conflicted] x found in 3 packages.
      Either pick the one you want with `::`:
      * a::x
      * b::x
      * c::x
      Or declare a preference with `conflicts_prefer()`:
      * `conflicts_prefer(a::x)`
      * `conflicts_prefer(b::x)`
      * `conflicts_prefer(c::x)`
    Code
      disambiguate_prefix("if", c("a", "b", "c"))()
    Condition
      Error:
      ! [conflicted] if found in 3 packages.
      Either pick the one you want with `::`:
      * a::`if`
      * b::`if`
      * c::`if`
      Or declare a preference with `conflicts_prefer()`:
      * `` conflicts_prefer(a::`if`) ``
      * `` conflicts_prefer(b::`if`) ``
      * `` conflicts_prefer(c::`if`) ``
    Code
      disambiguate_infix("%in%", c("a", "b", "c"))()
    Condition
      Error:
      ! [conflicted] %in% found in 3 packages.
      Declare a preference with `conflicts_prefer()`:
      * `` conflicts_prefer(a::`%in%`) ``
      * `` conflicts_prefer(b::`%in%`) ``
      * `` conflicts_prefer(c::`%in%`) ``

# display namespace if not attached

    Code
      cnds$prefix
    Output
      <error/rlang_error>
      Error:
      ! [conflicted] x found in 3 packages.
      Either pick the one you want with `::`:
      * a::x
      * b::x
      * c::x
      Or declare a preference with `conflicted::conflicts_prefer()`:
      * `conflicted::conflicts_prefer(a::x)`
      * `conflicted::conflicts_prefer(b::x)`
      * `conflicted::conflicts_prefer(c::x)`
    Code
      cnds$infix
    Output
      <error/rlang_error>
      Error:
      ! [conflicted] %in% found in 3 packages.
      Declare a preference with `conflicted::conflicts_prefer()`:
      * `` conflicted::conflicts_prefer(a::`%in%`) ``
      * `` conflicted::conflicts_prefer(b::`%in%`) ``
      * `` conflicted::conflicts_prefer(c::`%in%`) ``

