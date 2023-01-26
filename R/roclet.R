#' Roclet for 'roxygen2' style linting
#'
#' Roclets used to embed linters during documentation. To use, add the roclet in
#' your `DESCRIPTION` file.
#'
#' ```
#' Config/Needs/documentation: roxylint
#' Roxygen:
#'   list(
#'     markdown = TRUE,
#'     roclets = c("namespace", "rd", "roxylint::roxylint")
#'   )
#' ```
#'
#' @return A `roxylint` [roxygen2::roclet()].
#'
#' @export
roxylint <- function() {
  roxygen2::roclet("roxylint")
}


#' @exportS3Method roxygen2::roclet_process roclet_roxylint
#' @noRd
roclet_process.roclet_roxylint <- function(x, blocks, env, base_path) {  # nolint
  config <- config_load()

  for (block in blocks) {
    for (x in block$tags) {
      linters <- config$linters[[x$tag]]
      check_linter(linters, x)
    }
  }

  invisible(NULL)
}


#' @exportS3Method roxygen2::roclet_output roclet_roxylint
#' @noRd
roclet_output.roclet_roxylint <- function(...) {  # nolint
  invisible(NULL)
}
