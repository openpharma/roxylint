# `roxylint`

<!-- badges: start -->
[![R-CMD-check](https://github.com/dgkf/roxylint/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/dgkf/roxylint/actions/workflows/R-CMD-check.yaml)
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
      "details should be in 'ALL CAPS'" = "^[[:upper:] ]*$"
    ),

    # use functions for fine-grained control
    param = function(x, name, description, ...) {
      n_caps <- nchar(gsub("[^[:upper:]]", "", description))
      if (n_caps < nchar(description) / 2)
        warning("descriptions should be at least 50% CaPiTALiZeD")
    }
  )
)
```

With these in place, you'll start getting alerts when you're deviating from your
style.

```
ℹ [config.R:12] @title raw value does not match '!!!$'
ℹ [config.R:17] @param descriptions should be at least 50% CaPiTALiZeD
ℹ [linters.R:7] @details details should be in 'ALL CAPS'
ℹ [roxy_tag_rd.R:1] @title raw value does not match '!!!$'
ℹ [roxy_tag_rd.R:7] @return descriptions should be 'Sentence case' and end in a period
```
