#' Retrieves Analytics Table Data from KHIS
#'
#' `.get_analytics()` fetches data from the KHIS analytics data tables for a
#'   given period and data element(s), without performing any aggregation.
#'
#' @param element_ids A vector of data element IDs for which to retrieve data. Required.
#' @param start_date The start date to retrieve data. It is required and in the format `YYYY-MM-dd`.
#' @param end_date The ending date for data retrieval (default is the current date).
#' @param level The desired data granularity: `"country"` (the default), `"county"`, `"subcounty"`, `"ward"`, or `"facility"`.
#' @param organisations A list of organization units in the data. If NULL, downloaded using [get_organisation_units_metadata()].
#' @param elements A list of data elements to include. If NULL, downloaded using [get_data_elements_metadata()].
#' @param ... Other options that can be passed onto KHIS API.
#'
#' @details
#' * Retrieves data directly from KHIS analytics tables.
#' * Supports optional arguments for providing organization lists, data elements, and categories.
#' * Allows specifying KHIS session objects, retry attempts, and logging verbosity.
#'
#' @return A tibble with detailed information, including:
#'
#' * Geographical identifiers (country, county, subcounty, ward, facility, depending on level)
#' * Reporting period (month, year, fiscal year)
#' * Data element names
#' * Category options
#' * Reported values
#'
#' @noRd
#'
#' @seealso
#' * [get_organisation_units_metadata()] for getting the organisations units
#' * [get_data_elements_metadata()] for retrieving the data elements
#'
#' @examplesIf khis_has_cred()
#' # Clinical Breast Examination data elements
#' # XEX93uLsAm2 = CBE Abnormal
#' # cXe64Yk0QMY = CBE Normal
#' element_id = c('cXe64Yk0QMY', 'XEX93uLsAm2')
#'
#' # Download data from February 2023 to current date
#' data <- get_analytics(element_ids = element_id,
#'                       start_date = '2023-02-01')
#' data

.get_analytics <- function(element_ids,
                          start_date,
                          end_date = NULL,
                          level = c('country', 'county', 'subcounty', 'ward', 'facility'),
                          organisations = NULL,
                          elements = NULL,
                          ...) {

  dx = co = ou = pe = value = period = NULL # due to NSE notes in R CMD check

  check_string_vector(element_ids)
  check_date(start_date)
  check_date(end_date, can_be_null = TRUE)

  level <- arg_match(level)

  ou_level <- switch (level,
                   kenya = 'LEVEL-1',
                   county = 'LEVEL-2',
                   subcounty = 'LEVEL-3',
                   ward = 'LEVEL-4',
                   facility = 'LEVEL-5')

  if (is.null(end_date)) {
    end_date = today()
  }

  data <- get_analytics(
    dx %.d% element_ids,
    pe %.d% 'all',
    ou %.d% c(ou_level, 'HfVjCurKxh2'),
    co %.d% 'all',
    startDate = start_date,
    endDate = end_date
  )

  if (is_empty(data)) {
    return(NULL)
  }

  if (is.null(organisations)) {
    cancerscreening_bullets(c("i" = "Downloading organisation units"))
    organisations <- get_organisation_units_metadata(data$ou, level = level)
  }

  if (is.null(elements)) {
    cancerscreening_bullets(c("i" = "Downloading data elements"))
    elements <- get_data_elements_metadata(element_ids)
  }

  data <- data %>%
    left_join(organisations, by=c('ou' = 'id')) %>%
    left_join(elements, by=c('dx'='element_id', 'co'='category_id')) %>%
    mutate(
      period = ym(pe),
      month = month(period, label = TRUE, abbr = FALSE),
      year = year(period),
      fiscal_year = as.integer(quarter(period, fiscal_start = 7, type='year.quarter')),
      fiscal_year = factor(str_glue('{fiscal_year-1}/{fiscal_year}'))
    ) %>%
    select(-ou, -co, -dx, -pe)

  return(data)
}
