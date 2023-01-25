#' Roclet for 'roxygen2' style linting
#'
#' @return A `roxylint` [roxygen2::roclet()].
#'
#' @export
roxylint <- function() {
  roxygen2::roclet("roxylint")
}


#' @describeIn roxylint
#' For each tag scanned by 'roxygen2', apply any linters
#'
#' @exportS3Method roxygen2::roclet_process roclet_roxylint
roclet_process.roclet_roxylint <- function(x, blocks, env, base_path) {  # nolint
  config <- config_load()
  for (block in blocks) {
    for (x in block$tags) {
      linters <- config$linters[[x$tag]]
      check_linter(linters, x)
    }
  }
}


#' @describeIn roxylint
#' Unused
#'
#' @exportS3Method roxygen2::roclet_output roclet_roxylint
roclet_output.roclet_roxylint <- function(...) {  # nolint
  invisible(NULL)
}
