#' Retrieves Data Set Reporting Rate Metrics
#'
#' `get_data_sets_formatted()` fetches the data set reporting metrics. The metric
#' can be REPORTING_RATE, REPORTING_RATE_ON_TIME, ACTUAL_REPORTS, ACTUAL_REPORTS_ON_TIME, EXPECTED_REPORTS.
#'
#' @param datasets_ids A vector of data sets IDs for which to retrieve data. Required.
#' @param start_date The start date to retrieve data. It is required and in the format `YYYY-MM-dd`.
#' @param end_date The ending date for data retrieval (default is the current date).
#' @param level The desired data granularity: `"country"` (the default), `"county"`, `"subcounty"`, `"ward"`, or `"facility"`.
#' @param organisations A list of organization units ids to be filtered.
#' @param ... Other options that can be passed onto KHIS API.
#'
#' @return A tibble with detailed information, including:
#'
#' * Geographical identifiers (country, county, subcounty, ward, facility, depending on level)
#' * Reporting period (month, year, fiscal year)
#' * The reporting metric can be REPORTING_RATE, REPORTING_RATE_ON_TIME, ACTUAL_REPORTS, ACTUAL_REPORTS_ON_TIME, EXPECTED_REPORTS.
#'
#' @export
#'
#' @seealso
#' * [get_organisation_units_metadata()] for getting the organisations units
#' * [get_data_sets()] for retrieving the data sets
#'
#' @examplesIf khis_has_cred()
#' # The MoH 745 Cancer Screening Program Monthly Summary Form
#' dataset_id = c('WWh5hbCmvND')
#'
#' # Download data from February 2023 to current date
#' data <- get_data_sets_formatted(element_ids = element_id,
#'                                 start_date = '2023-02-01')
#' data

get_data_sets_formatted <- function(dataset_ids,
                                    start_date,
                                    end_date = NULL,
                                    level = c('country', 'county', 'subcounty', 'ward', 'facility'),
                                    organisations = NULL) {

  dx = pe = ou = element = value = NULL # due to NSE notes in R CMD check

  check_string_vector(dataset_ids)
  check_date(start_date)
  check_date(end_date, can_be_null = TRUE)

  level <- arg_match(level)
  ou_level <- switch (level,
                   country = 'LEVEL-1',
                   county = 'LEVEL-2',
                   subcounty = 'LEVEL-3',
                   ward = 'LEVEL-4',
                   facility = 'LEVEL-5')

  values <- c('REPORTING_RATE',
              'REPORTING_RATE_ON_TIME',
              'ACTUAL_REPORTS',
              'ACTUAL_REPORTS_ON_TIME',
              'EXPECTED_REPORTS')

  dataset_ids_str <- str_c(dataset_ids, values, sep = '.')
  if (is.null(end_date)) {
    end_date = today()
  }
  periods <- format(seq(ymd(start_date), ymd(end_date), by = 'month'), '%Y%m')

  ou <- 'HfVjCurKxh2' # Kenya
  if (!is.null(organisations)) {
    ou <- organisations
  }

  data <- get_analytics(
    dx %.d% dataset_ids_str,
    pe %.d% periods,
    ou %.d% c(ou_level, ou)
  )

  organisations <- get_organisation_units_metadata(data$ou, level = level)
  datasets <- get_data_sets(id %.in% dataset_ids, fields = 'id,name~rename(dataset)')

  data <- data %>%
    separate_wider_delim(dx, ".",  names = c('dx','element')) %>%
    left_join(organisations, by = c('ou'='id'), relationship = 'many-to-many') %>%
    left_join(datasets, by = c('dx'='id'), relationship = 'many-to-many') %>%
    mutate(
      element = tolower(element),
      period = ym(pe),
      month = month(period, label = TRUE, abbr = FALSE),
      year = year(period),
      fiscal_year = as.integer(quarter(period, fiscal_start = 7, type='year.quarter')),
      fiscal_year = factor(str_glue('{fiscal_year-1}/{fiscal_year}'))
    ) %>%
    select(-ou,-dx,-pe) %>%
    pivot_wider(names_from = element, values_from = value, values_fill = 0)

  return(data)
}
