check_date <- function(date, can_be_null = FALSE, arg = caller_arg(date), error_call = caller_env()) {

  check_required(date, arg = arg, call = error_call)

  parsed_date <- lubridate::ymd(date, quiet = TRUE)
  if (any(length(parsed_date) > 1,
          is_na(parsed_date),
          (length(parsed_date) == 0 && !can_be_null))) {
    cancerscreening_abort(
      message = c(
        "x" = "{.arg {arg}} has incorrect format",
        "!" = "Provide the date in the format {.code yyyy-mm-dd}"
      ),
      class = 'cancerscreening_invalid_date',
      call = error_call
    )
  }
}

check_string_vector <- function(vec, arg = caller_arg(vec), error_call = caller_env()) {

  check_required(vec, arg = arg, call = error_call)

  is_string <- is_character(vec)
  no_null_na <- !any(is_null(vec) | is.na(vec))
  not_empty <- vec != ""

  if (!all(is_string, no_null_na, not_empty)) {
    cancerscreening_abort(
      message = c(
        "x" = "{.arg {arg}} contains invalid values",
        "!" = "Provide values without {.code NA}, {.code NULL} or empty string"
      ),
      class = 'cancerscreening_invalid_string_vectors',
      call = error_call
    )
  }
}

check_numeric <- function(number, arg = caller_arg(number), error_call = caller_env()) {

  check_required(number, arg = arg, call = error_call)

  if (length(number) > 1 || !is.numeric(number)) {
    cancerscreening_abort(
      c('x' = '{.arg {arg}} should be scalar numeric'),
      class = 'cancerscreening_invalid_numeric',
      call = error_call
    )
  }
}
