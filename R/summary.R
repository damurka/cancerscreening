#' @export
summary.cacx_screened <- function(object, ...) {
  if (is.null(object)) {
    cancerscreening_abort('x' = 'dataframe is null.')
  }

  data_name <- deparse(substitute(object))
  level <- data_level(object)
  orgs <- n_distinct(object[[level]])
  period <- object$period
  min_period <- min(period)
  max_period <- max(period)
  months <- ((min_period %--% max_period) /months(1)) + 1
  sources <- object %>%
    distinct(source) %>%
    pull(source)
  categories <- object %>%
    distinct(age_group) %>%
    pull(age_group)

  ou_level <- ifelse(level %in% c('subcounty', 'ward', 'facility'), 'county', level)

  target <- get_cervical_target_population(year(max_period), ou_level)

  object <- object %>%
    filter(age_group == '25-49') %>%
    group_by(across(any_of(ou_level))) %>%
    summarise(
      screened = sum(value)
    ) %>%
    left_join(target, by=ou_level) %>%
    mutate(
      target = target/12 * months,
      coverage = screened/target
    )

  vctrs::new_data_frame(
    df_list(object),
    class = c('summary_cacx_screened', 'tbl'),
    data_orgs = orgs,
    data_level = level,
    data_period = str_c(format(min_period, '%B %Y'), ' to ', format(max_period, '%B %Y')),
    data_months = str_c(months, ' months'),
    data_sources = str_c(sources, collapse = ', '),
    data_categories = str_c(categories, collapse = ', '),
    data_name = data_name
  )
}

#' @export
tbl_sum.summary_cacx_screened <- function(x, ...) {
  default_header <- NextMethod()
  summary_values <- get_summary_values(x)
  names(summary_values) <- get_summary_dnames(x)

  c(
    default_header,
    summary_values
  )
}

get_summary_dnames <- function(summary_object) {
  c(
    'Data name',
    'Organisations level',
    'Number of organisations',
    'Period',
    'Months',
    'Sources',
    'Categories'
  )
}

get_summary_values <- function(summary_object) {
  c(
    data_name(summary_object),
    data_level(summary_object),
    data_orgs(summary_object),
    data_period(summary_object),
    data_months(summary_object),
    data_sources(summary_object),
    data_categories(summary_object)
  )
}

data_name <- function(object) {
  attr(object, 'data_name')
}

data_orgs <- function(object) {
  attr(object, 'data_orgs')
}

data_level <- function(object) {
  attr(object, 'data_level')
}

data_period <- function(object) {
  attr(object, 'data_period')
}

data_months <- function(object) {
  attr(object, 'data_months')
}

data_sources <- function(object) {
  attr(object, 'data_sources')
}

data_categories <- function(object) {
  attr(object, 'data_categories')
}
