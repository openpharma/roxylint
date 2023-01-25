#' Environment value name to use for storing config
#'
#' This constant is used as a variable name in the package environment while
#' documentation is being built to avoid constantly parsing configurations
#' during evaluation of each tag.
#'
#' @importFrom utils packageName
#' @noRd
CONFIG <- paste0(".", utils::packageName(), "_config")  # nolint


#' Configuration
#'
#' Various functions for loading, caching and performing configured behaviors
#' using a user-supplied configuration file.
#'
#' @param path A file path to use when searching for a config file. Either the
#'   file path to a `DESCRIPTION` or the root path of a package, depending on
#'   the context of the function.
#'
#' @name config
.state <- new.env(parent = emptyenv())


#' @describeIn config
#' Load the contents of a config into an environment
#'
#' @keywords internal
config_load <- function() {
  if (exists(CONFIG, envir = .state)) return(.state[[CONFIG]])
  config <- config_find_from(getwd())
  .state[[CONFIG]] <- config
}


#' @describeIn config
#' Load a configuration from a path
#'
#' @keywords internal
config_find_from <- function(path) {
  repeat {
    if (file.exists(file.path(path, "DESCRIPTION"))) break
    if (dirname(path) == path) return(list())
    path <- dirname(path)
  }

  config_desc <- config_from_desc(path)
  config_file <- config_from_file(path)

  if (!is.null(config_desc) && !is.null(config_file))
    stop(errors$redundant_config)

  config_desc %||% config_file
}


#' @describeIn config
#' Load a configuration from a DESCRIPTION file
#'
#' @importFrom utils packageName
#' @keywords internal
config_from_desc <- function(path) {
  path <- file.path(path, "DESCRIPTION")

  field <- paste0("Config/", utils::packageName())
  config_desc <- read.dcf(path, fields = field)[1, field]

  result <- tryCatch(
    eval(parse(text = config_desc)),
    error = function(e) stop(errors$description_parse_failure(e$message))
  )

  if (length(result) == 0 || is.na(result)) return(NULL)
  result
}


#' @describeIn config
#' Load a configuration from a dotfile
#'
#' @importFrom utils packageName
#' @keywords internal
config_from_file <- function(path) {
  pattern <- "^meta\\.[rR]"

  path <- file.path(path, "man", utils::packageName())
  config_files <- list.files(
    path,
    pattern = pattern,
    all.files = TRUE,
    full.names = TRUE
  )

  if (length(config_files) == 0)
    return(NULL)

  res <- new.env()
  source(config_files[[1]], local = res)[[1]]
}
