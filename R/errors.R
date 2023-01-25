#' Errors used internally
#'
#' @importFrom utils packageName
#' @noRd
errors <- list(
  # Multiple config options were used, likely accidentally
  redundant_config = paste0(
    "Redundant roxytypes configs found:\n",
    " * DESCRIPTION [Config/", utils::packageName(), "]\n",
    " * ./man/", utils::packageName(), "/meta.R"
  ),

  # While parsing a config from DESCRIPTION, a parse or eval failure occured
  description_parse_failure = function(msg) {
    paste0(
      "Could not parse DESCRIPTION contents at Config/", utils::packageName(), "\n",
      msg
    )
  }
)
