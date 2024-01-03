#' Create a Theme for Messages with Bullets
#'
#' @noRd

cancerscreening_theme <- function() {
  list(
    span.field = list(transform = single_quote_if_no_color),
    span.fun = list(color = "cyan"),
    # since we're using color so much elsewhere, I think
    # the standard bullet should be "normal" color
    ".bullets .bullet-*" = list(
      "text-exdent" = 2,
      before = function(x) paste0(cli::symbol$bullet, " ")
    )
  )
}

#' Write Messages with Bullets
#'
#' @noRd

cancerscreening_bullets <- function(text, .envir = parent.frame()) {
  quiet <- cancerscreening_quiet() %|% testthat::is_testing()
  if (quiet) {
    return(invisible())
  }
  cli::cli_div(theme = cancerscreening_theme())
  cli::cli_bullets(text = text, .envir = .envir)
}

#' Abort/Error Message with Bullets
#'
#' @noRd

cancerscreening_abort <- function(message, ..., .envir = parent.frame()) {
  cli::cli_div(theme = cancerscreening_theme())
  cli::cli_abort(message = message, ..., .envir = .envir)
}

single_quote_if_no_color <- function(x) quote_if_no_color(x, "'")
double_quote_if_no_color <- function(x) quote_if_no_color(x, '"')

quote_if_no_color <- function(x, quote = "'") {
  # TODO: if a better way appears in cli, use it
  # @gabor says: "if you want to have before and after for the no-color case
  # only, we can have a selector for that, such as:
  # span.field::no-color
  # (but, at the time I write this, cli does not support this yet)
  if (cli::num_ansi_colors() > 1) {
    x
  } else {
    paste0(quote, x, quote)
  }
}

#' Making cancerscreening quiet vs. loud ----
#'
#' @noRd
cancerscreening_quiet <- function() {
  getOption("cancerscreening_quiet", default = NA)
}

