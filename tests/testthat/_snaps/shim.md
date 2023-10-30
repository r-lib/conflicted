# package_name throws errors with invalid names

    Code
      package_name_(c("x", "y"))
    Condition
      Error in `package_name()`:
      ! `package` must be character vector of length 1.
    Code
      package_name_(1:10)
    Condition
      Error in `package_name()`:
      ! `package` must be character vector of length 1.
    Code
      package_name_(NA_character_)
    Condition
      Error in `package_name()`:
      ! `package` must not be NA or ''.
    Code
      package_name_("")
    Condition
      Error in `package_name()`:
      ! `package` must not be NA or ''.

