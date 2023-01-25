#' If-not-null-else
#'
#' @name if-not-null-else
#' @keywords internal
`%||%` <- function(lhs, rhs) if (is.null(lhs)) rhs else lhs


#' Get that tag!
#'
#' Tools for inspecting [roxygen2::roxy_tag()]s. This can be helpful for
#' exploring the intermediate tag objects. For example, you can use this
#' function to generate a tag and explore the named values in `$val`.
#'
#' @section test:
#' 1234
#'
#' @param str A 'roxygen2' tag string.
#'
#' @return A [roxygen2::roxy_tag()]
#'
#' @examples
#' demo_tag("@param var abc")
#'
#' @export
demo_tag <- function(str) {
  str <- strsplit(str, "\n")[[1]]
  code <- paste0(paste0("#' ", str, collapse = "\n"), "\nNULL")
  res <- roxygen2::parse_text(code)
  res[[1]]$tags[[1]]
}
