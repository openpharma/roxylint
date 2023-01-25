#' Modified linting roxy tag evaluation
#'
#' Intercept `roxygen2` to perform linting.
#'
#' @inheritParams roxygen2::roxy_tag_rd
#'
#' @return A processed [roxygen2::roxy_tag()]
#'
#' @keywords internal
roxy_tag_rd <- function(x, base_path, env) {
  config <- config_load()
  linters <- config$linters[[x$tag]]
  check_linter(linters, x)
  UseMethod("roxy_tag_rd")
}
