cancerscreening_theme <- function() {
  list(
    span.field = list(transform = single_quote_if_no_color),
    # I want to style the Drive file names similar to cli's,
    span.drivepath = list(
      color = "cyan",
      fmt = utils::getFromNamespace("quote_weird_name", "cli")
    ),
    # since we're using color so much elsewhere, I think
    # the standard bullet should be "normal" color
    ".bullets .bullet-*" = list(
      "text-exdent" = 2,
      before = function(x) paste0(cli::symbol$bullet, " ")
    )
  )
}

cancerscreening_bullets <- function(text, .envir = parent.frame()) {
  quiet <- cancerscreening_quiet() %|% testthat::is_testing()
  if (quiet) {
    return(invisible())
  }
  cli::cli_div(theme = cancerscreening_theme())
  cli::cli_bullets(text = text, .envir = .envir)
}

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

# making cancerscreening quiet vs. loud ----
cancerscreening_quiet <- function() {
  getOption("cancerscreening_quiet", default = NA)
}

