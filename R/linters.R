#' Assorted linters
#'
#' Preconfigured linters, either as a collective list of linters or
#' individually. "tidy" linters implement guidelines from the tidyverse style
#' guide.
#'
#' Refer to the individual [roxygen2::roxy_tag()] for the respective tag for
#' argument details.
#'
#' @param x A [roxygen2::roxy_tag()] that is the subject of linting.
#' @param name,description Used for [roxygen2::roxy_tag()]-specific linters.
#' @param ... Additional arguments unused.
#'
#' @name linters
NULL


#' @describeIn linters
#' Lowercase start linting. (uses `$raw` for [roxygen2::roxy_tag()]s)
#'
#' @export
lint_starts_lowercase <- function(x, ...) {
  UseMethod("lint_sentence_case")
}

#' @export
lint_starts_lowercase.roxy_tag <- function(x, ...) {
  lint_starts_lowercase(x$raw, ...)
}

#' @export
lint_starts_lowercase.character <- function(x, ...) {
  re <- "^[^[:upper:]]"
  if (!grepl(re, trimws(x)))
    message("should not start with an uppercase letter")
}


#' @describeIn linters
#' Ends in a full stop. (uses `$raw` for [roxygen2::roxy_tag()]s)
#'
#' @export
lint_full_stop <- function(x, ...) {
  UseMethod("lint_full_stop")
}

#' @export
lint_full_stop.roxy_tag <- function(x, ...) {
  lint_full_stop(x$raw, ...)
}

#' @export
lint_full_stop.character <- function(x, ...) {
  re <- "\\.$"
  if (!grepl(re, trimws(x)))
    message("should terminate with a full stop, `.`")
}


#' @describeIn linters
#' Does not end in a full stop. (uses `$raw` for [roxygen2::roxy_tag()]s)
#'
#' @export
lint_no_full_stop <- function(x, ...) {
  UseMethod("lint_no_full_stop")
}

#' @export
lint_no_full_stop.roxy_tag <- function(x, ...) {
  lint_no_full_stop(x$raw, ...)
}

#' @export
lint_no_full_stop.character <- function(x, ...) {
  re <- "[^.]$"
  if (!grepl(re, trimws(x)))
    message("should not terminate with a full stop, `.`")
}


#' @describeIn linters
#' Sentence case linting (uses `$raw` for [roxygen2::roxy_tag()]s)
#'
#' @export
lint_sentence_case <- function(x, ...) {
  UseMethod("lint_sentence_case")
}

#' @export
lint_sentence_case.roxy_tag <- function(x, ...) {
  lint_sentence_case(x$raw, ...)
}

#' @export
lint_sentence_case.character <- function(x, ...) {
  words <- strsplit(trimws(x), " ")[[1L]]

  # find any first words in sentences (at start, or after full stop)
  has_stop <- grepl("\\.$", words)
  is_start <- rep_len(FALSE, length.out = length(words))
  is_start[[1]] <- TRUE
  is_start[-1] <- has_stop[-length(words)]

  first_cap <- all(grepl("^[^[:lower:]]", words[is_start]))
  rest_lower <- all(grepl("^[^[:upper:]]", words[!is_start]))

  if (!(first_cap && rest_lower))
    message("should be 'Sentence case'")
}


#' @describeIn linters
#' Title case linting
#'
#' @export
lint_title_case <- function(x, ...) {
  UseMethod("lint_title_case")
}

#' @export
lint_title_case.roxy_tag <- function(x, ...) {
  lint_title_case(x$raw, ...)
}

#' @export
lint_title_case.character <- function(x, ...) {
  # AP style title case rules
  words <- strsplit(x, " ")[[1L]]
  exceptions <- c(
    "a", "an", "the",  # articles
    "and", "but", "for",  # coordinating conjunctions
    "at", "by", "to", "of", "on", "off", "out"  # prepositions
  )

  is_exception <- tolower(words) %in% exceptions
  is_exception[[1]] <- FALSE
  is_exception[[length(words)]] <- FALSE

  if (any(grepl("^[[:lower:]]", words) & !is_exception))
    message("should be 'Title Case'")
}


#' @describeIn linters
#' Tidy 'Sentence case' titles
#'
#' @export
tidy_title <- function(x, ...) {
  lint_sentence_case(x$raw)
  lint_no_full_stop(x$raw)
}


#' @describeIn linters
#' Tidy 'Sentence case' `@param` definitions
#'
#' @export
tidy_param <- function(x, name, description, ...) {
  lint_sentence_case(description)
  lint_full_stop(description)
}


#' @describeIn linters
#' Tidy 'Sentence case' `@return` definitions
#'
#' @export
tidy_return <- function(x, ...) {
  lint_sentence_case(x$val)
  lint_full_stop(x$val)
}


#' @describeIn linters
#' Tidy 'Sentence case' `@seealso` definitions
#'
#' @export
tidy_seealso <- function(x, ...) {
  lint_sentence_case(x$val)
  lint_full_stop(x$val)
}


#' @describeIn linters
#' A list of all tidyverse style guide inspired linters
#'
#' @export
tidy <- list(
  title = tidy_title,
  param = tidy_param,
  return = tidy_return,
  seealso = tidy_seealso
)
