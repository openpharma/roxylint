# `roxylint`

<!-- badges: start -->
[![R-CMD-check](https://github.com/openpharma/roxylint/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/openpharma/roxylint/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

Lint 'roxygen2'-generated documentation

## Quick Start

Modify your package's description file to add required package for your 
`roxygen2` documentation

`DESCRIPTION`
```
Config/Needs/documentation: roxylint
Roxygen: list(markdown = TRUE, roclets = c("namespace", "rd", "roxylint::roxylint"))
```

By default, this will add linters for the tidyverse style guide. If you'd like
to be explicit, you can declare this style yourself:

`DESCRIPTION`
```
Config/roxylint: list(linters = roxylint::tidy)
```

Now, the next time you document your package, you might see some messages about 
your formatting!

## Tune your Linting

You can add in your own linters easily. Simply modify the `linters` field in the
configuration list. Of course, if you feel that your linter would be more widely
useful, feel free to open up a pull request to introduce it.

However, since structuring code in the `DESCRIPTION` file is not very pleasant,
you can instead store your configurations in `man/roxylint/meta.R`.

For example, it might look something like this:

`man/roxytypes/meta.R`
```r
list(
  linters = list(
    # pick and choose your tidy lints
    return = roxylint::lint_sentence_case,

    # use regular expressions to set simple rules
    title = "!!!$",

    # add custom messages with named lists
    details = list(
      "should be in 'ALL CAPS'" = "^[[:upper:] ]*$"
    ),

    # use functions for fine-grained control
    param = function(x, name, description, ...) {
      n_caps <- nchar(gsub("[^[:upper:]]", "", description))
      if (n_caps < nchar(description) / 2)
        warning("descriptions should be at least 50% CaPiTALiZeD")
    },

    # use multiple rules in a list
    section = list(
      "should not have frowny faces" = ":\\(",
      function(x, ...) if (grepl(":\\)", x$raw)) message("nice! very happy :)")
    ),

    # prevent other packages from registering rules with a `NULL`
    yell = NULL,

    # or prevent aditional rules by ending a list with a `NULL`
    return = list(
      "^Returns ",
      NULL
    )
  )
)
```

With these in place, you'll start getting alerts when you're deviating from your
style.

```
ℹ [check_linter.R:1] @title raw value does not match '!!!$'
ℹ [check_linter.R:6] @param descriptions should be at least 50% CaPiTALiZeD
ℹ [check_linter.R:13] @return descriptions should be 'Sentence case' and end in a period
```

## Register Linters

If you're building a package that provides its own `roxygen2` tags, you can also
register default linters.

`DESCRIPTION`
```
Enhances:
    roxylint
```

```r
.onLoad <- function(libname, pkgname) {
  if (requireNamespace("roxylint", quietly = TRUE)) {
    roxylint::register_linters(
      yell = "^[[:upper:] ]*$"
    )
  }
}
```
