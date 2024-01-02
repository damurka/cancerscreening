#' Retrieves Analytics Table Data from KHIS
#'
#' `get_analytics()` fetches data from the KHIS analytics data tables for a
#'   given period and data element(s), without performing any aggregation.
#'
#' @param element_ids A vector of data element IDs for which to retrieve data. Required.
#' @param start_date The start date to retrieve data. It is required and in the format 'YYYY-MM-dd'.
#' @param end_date The ending date for data retrieval (default is the current date).
#' @param level The desired data granularity: `"kenya"` (the default), `"county"`, `"subcounty"`, `"ward"`, or `"facility"`.
#' @param organisations A list of organization units in the data. If NULL, downloaded using [get_organisation_units_metadata()].
#' @param categories A list of categories to include. If NULL, downloaded using [get_category_options_metadata()].
#' @param elements A list of data elements to include. If NULL, downloaded using [get_data_elements_metadata()].
#' @param ... Other options that can be passed onto [.api_get].
#'
#' @details
#' * Retrieves data directly from KHIS analytics tables.
#' * Supports optional arguments for providing organization lists, data elements, and categories.
#' * Allows specifying KHIS session objects, retry attempts, and logging verbosity.
#'
#' @return A tibble with detailed information, including:
#'
#' * Geographical identifiers (kenya, county, subcounty, ward, facility, depending on level)
#' * Reporting period (month, year, fiscal year)
#' * Data element names
#' * Category options
#' * Reported values
#'
#' @export
#'
#' @seealso
#'   [get_organisation_units_metadata()] for getting the organisations units
#'   [get_data_elements_metadata()] for retrieving the data elements
#'   [get_category_options_metadata()] for retrieving category options
#'   [.api_get()] for making API call to KHIS server
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

get_analytics <- function(element_ids,
                          start_date,
                          end_date = NULL,
                          level = c('kenya', 'county', 'subcounty', 'ward', 'facility'),
                          organisations = NULL,
                          categories = NULL,
                          elements = NULL,
                          ...) {

  x = element_id = `x,1` = category_id = `x,2` = org_id = `x,3` = period = `x,4` = value = `x,5` = category = category2 = year_f = NULL # due to NSE notes in R CMD check

  stopifnot(length(element_ids) > 0)
  stopifnot(!is.na(start_date), !is.na(as.Date(start_date, '%Y-%m-%d')))
  if (!is.null(end_date) && is.na(as.Date(end_date, '%Y-%m-%d'))) {
    stop('end_date is in an incorrect format')
  }

  level <- match.arg(level)

  if (is.null(organisations)) {
    organisations <- get_organisation_units_metadata()
  }
  organisations <- .filter_organisation_units(organisations, level)

  if (is.null(categories)) {
    categories <- get_category_options_metadata()
  }

  if (is.null(elements)) {
    elements <- get_data_elements_metadata(element_ids)
  }

  level <- switch (level,
                   kenya = 'LEVEL-1',
                   county = 'LEVEL-2',
                   subcounty = 'LEVEL-3',
                   ward = 'LEVEL-4',
                   facility = 'LEVEL-5')

  dx <- str_c(element_ids, collapse = ';')
  dx <- str_c('dx', dx, sep = ':')

  if (is.null(end_date)) {
    end_date = today()
  }

  data <- .api_get('analytics',
                  dimension=dx,
                  dimension = str_c('ou:',level, ';HfVjCurKxh2'),
                  dimension = 'co',
                  dimension = 'pe',
                  startDate =start_date,
                  endDate = end_date,
                  skipData = FALSE,
                  skipMeta = TRUE,
                  ...
  )

  if (is.null(data$rows) || length(data$rows) == 0) {
    cancerscreening_abort(
      message = c(
        "No data",
        "x" = "There was no data returned by the sever"
      ),

    )
  }

  data <- tibble(x = data$rows) %>%
    unnest_wider(x, names_sep = ',') %>%
    rename(
      element_id = `x,1`,
      category_id = `x,2`,
      org_id = `x,3`,
      period = `x,4`,
      value = `x,5`
    ) %>%
    left_join(organisations, by='org_id') %>%
    left_join(categories, by='category_id', relationship='many-to-many') %>%
    left_join(elements, by='element_id') %>%
    group_by(category_id, org_id, element_id, period, value) %>%
    mutate(category = str_c(category, collapse = ",")) %>%
    distinct(category_id, .keep_all = TRUE) %>%
    ungroup() %>%
    separate(category, c('category', 'category2'), sep=',', remove = TRUE, fill='right') %>%
    mutate(
      period = ym(period),
      month = month(period, label = TRUE, abbr = FALSE),
      year = year(period),
      year_f = as.integer(quarter(period, fiscal_start = 7, type='year.quarter')),
      fiscal_year = factor(str_c(ifelse(year_f == year, year-1, year), year_f, sep = '/')),
      value = as.integer(value),
      category2 = factor(str_trim(category2))
    ) %>%
    select(-org_id, -category_id, -element_id, -year_f)

  return(data)
}
