into_roxy_alert <- function(tag, expr) {
  res <- withCallingHandlers(
    capture.output({
      eval(expr)
      invisible(NULL)
    }),
    message = function(m) {
      cli::cli_alert_info(paste(format_tag_prefix(tag), m$message))
      invokeRestart("muffleMessage")
    },
    warning = function(w) {
      cli::cli_alert_info(paste(format_tag_prefix(tag), w$message))
      invokeRestart("muffleWarning")
    }
  )

  if (length(res) > 0) {
    cli::cli_alert(paste(format_tag_prefix(tag), paste0(res, collapse = " ")))
  }
}

format_tag_prefix <- function(x) {
  # inspired largely by roxygen2::link_to and roxygen2::warn_roxy_tag

  link <- cli::style_hyperlink(
    paste0(basename(x$file), ":", x$line),
    paste0("file://", x$file),
    params = c(line = x$line, col = 1)
  )

  paste0("[", link, "] @", x$tag)
}
