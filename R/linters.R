#' Linters
#'
#' Preconfigured linters, either as a collective list of linters or
#' individually. "tidy" linters implement guidelines from the tidyverse style
#' guide.
#'
#' Refer to the individual [roxygen2::roxy_tag()] for the respective tag for
#' argument details.
#'
#' @name linters
NULL


#' @describeIn linters
#' Lint sentence case (uses `$raw` for [roxygen2::roxy_tag()]s)
#'
#' @export
lint_sentence_case <- function(x, ...) {
  UseMethod("lint_sentence_case")
}

lint_sentence_case.roxy_tag <- function(x, ...) {
  lint_sentence_case(x$raw, ...)
}

lint_sentence_case.character <- function(x, ...) {
  re <- "^[[:upper:]](.|\\n)*\\.$"
  if (!grepl(re, trimws(x)))
    warning("descriptions should be 'Sentence case' and end in a period")
}


#' @describeIn linters
#' Tidy 'Sentence case' titles
#'
#' @export
tidy_title <- function(x, ...) {
  rd <- tools::parse_Rd(textConnection(x$val), fragment = TRUE)
  n <- length(rd)

  re <- "^[[:upper:]]"
  if ((attr(rd[[1]], "Rd_tag") == "TEXT") && !grepl(re, rd[[1]])) {
    warning("should start capitalized and be in 'Sentence case'")
    return()
  }

  re <- "\\.\\s*$"
  if ((attr(rd[[n]], "Rd_tag") == "TEXT") && grepl(re, rd[[n]])) {
    warning("should not be punctuated")
    return()
  }
}


#' @describeIn linters
#' Tidy 'Sentence case' parameter definitions
#'
#' @export
tidy_param <- function(x, name, description, ...) {
  lint_sentence_case(description)
}


#' @describeIn linters
#' A list of all tidyverse style guide inspired linters
#'
#' @export
tidy <- list(
  title = tidy_title,
  param = tidy_param
)
