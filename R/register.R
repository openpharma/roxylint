#' Register linters for new tags
#'
#' A registration mechanism for other packages to provide linters, either for
#' custom tags or to implement their own linting styles.
#'
#' @param ... Linters to register, with parameter names used to identify the
#'   associated tag.
#' @param linters Optionally, provide a named list of linters directly.
#' @param .overwrite Whether existing linters should be overwritten. Intended to
#'   be used sparingly. For example, this could be used to implement an entire
#'   new style guide without inheriting defaults.
#'
#' @return `TRUE`, invisibly.
#'
#' @export
register_linters <- function(..., linters = list(...), .overwrite = FALSE) {
  pkg <- eval(quote(packageName()), parent.frame())

  # don't cache, wait for registration to compile all config settings
  config <- config_load(cache = FALSE)
  if (isTRUE(config$verbose)) {
    cli::cli_alert_info("Registering roxylints from {.pkg {pkg}}")
  }

  reg_config <- list(
    source = pkg,
    overwrite = .overwrite,
    linters = linters
  )

  .registered[[pkg]] <- reg_config
  invisible(TRUE)
}


#' Add linters
#'
#' @param config A config object to add linters to.
#' @param tag The name of the tag to which to add linters.
#' @param linters New linters to add.
#' @param overwrite A logical value indicating whether existing linters should
#'   be overwritten.
#'
#' @return `NULL`.
#'
#' @keywords internal
add_linters <- function(config, tag, linters, overwrite = FALSE) {
  if (overwrite) {
    config$linters[[tag]] <- linters
  } else if (config_tag_accepts_linters(config, tag)) {
    config$linters[[tag]] <- append(config$linters[[tag]], linters)
  }
}


#' Check whether a given tag accepts new linters
#'
#' Linters can be configured to disallow new linter additions by providing a
#' trailing `NULL` value to a list, or setting the value itself to `NULL`.
#'
#' @inheritParams add_linters
#'
#' @keywords internal
config_tag_accepts_linters <- function(config, tag) {
  tag_cfg <- config$linters[[tag]]

  is_null <- tag %in% names(config$linters) && is.null(tag_cfg)
  ends_in_null <- is.list(tag_cfg) && is.null(tag_cfg[[length(tag_cfg)]])

  !is_null && !ends_in_null
}
