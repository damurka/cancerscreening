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
  quiet <- cancerscreening_quiet() %|% is_testing()
  if (quiet) {
    return(invisible())
  }
  cli::cli_div(theme = cancerscreening_theme())
  cli::cli_bullets(text = text, .envir = .envir)
}

#' Abort/Error Message with Bullets
#'
#' @noRd

cancerscreening_abort <- function(message, ..., .envir = parent.frame(), call = caller_env()) {
  cli::cli_div(theme = cancerscreening_theme())
  cli::cli_abort(message = message, ..., .envir = .envir, call = call)
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

is_testing <- function() {
  identical(Sys.getenv("TESTTHAT"), "true")
}

#' Making cancerscreening quiet vs. loud ----
#'
#' @noRd

cancerscreening_quiet <- function() {
  getOption("cancerscreening_quiet", default = NA)
}

#' @export
#' @rdname cancerscreening-configuration
#' @param code Code to execute quietly
with_cancerscreening_quiet <- function(code) {
  withr::with_options(list(cancerscreening_quiet = TRUE), code = code)
}

#' @export
#' @rdname cancerscreening-configuration
#' @param env The environment to use for scoping
#' @examplesIf khis_has_cred()
#' # message: "Downloading cervical cancer"
#' get_cervical_screening('2022-01-01')
#'
#' # suppress messages for a small amount of code
#' with_cancerscreening_quiet(
#'   get_breast_screening('2022-01-01')
#' )
#'
#' # message: "Writing ..., Appending ..."
#' get_breast_cbe_screening('2022-01-01')

local_cancerscreening_quiet <- function(env = parent.frame()) {
  withr::local_options(list(cancerscreening_quiet = TRUE), .local_envir = env)
}

local_cancerscreening_loud <- function(env = parent.frame()) {
  withr::local_options(list(cancerscreening_quiet = FALSE), .local_envir = env)
}

