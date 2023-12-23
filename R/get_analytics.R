#' Retrieves data for specified data elements from KHIS analytics tables
#'
#' @description
#' `get_analytics` fetches raw data from the KHIS analytics data tables for a
#'   given period and data element(s), without performing any aggregation.
#'
#' @details
#' * Retrieves data directly from KHIS analytics tables.
#' * Returns a tibble (data frame) with detailed information, including:
#'   - Geographical identifiers (kenya, county, subcounty, ward, facility, depending on level)
#'   - Reporting period (month, year, fiscal year)
#'   - Data element names
#'   - Category options
#'   - Reported values
#' * Supports optional arguments for providing organization lists, data elements, and categories.
#' * Allows specifying KHIS session objects, retry attempts, and logging verbosity.
#'
#' @param element_ids A vector of data element IDs for which to retrieve data. Required.
#' @param start_date The starting date for data retrieval in the format 'YYYY-MM-dd'. Required.
#' @param end_date The ending date for data retrieval (default is the current date).
#' @param level The desired data granularity: "kenya", "county", "subcounty", "ward", or "facility".
#' @param organisations A list of organization units to filter the data. If NULL, downloaded using `get_organisation_units()`.
#' @param categories A list of categories to include. If NULL, downloaded using `get_categories()`.
#' @param elements A list of data elements to include. If NULL, downloaded using `get_data_elements()`.
#' @param khis_session A KHIS session object to use for the API call. Defaults to the default session.
#' @param retry The number of times to retry the API call if it fails. Defaults to 1.
#' @param verbosity The level of detail to log for the API call. Defaults to 0 (no logging).
#'
#' @return A tibble containing the retrieved data.
#'
#' @seealso
#' get_organisation_units(), get_data_elements(), get_categories()
#'
#' @export


get_analytics <- function(element_ids,
                          start_date,
                          end_date = NULL,
                          level = c('kenya', 'county', 'subcounty', 'ward', 'facility'),
                          organisations = NULL,
                          categories = NULL,
                          elements = NULL,
                          khis_session = dynGet("khis_default_session", inherits = TRUE),
                          retry = 1,
                          verbosity = 0) {

  if (!is.vector(element_ids) || length(element_ids) == 0) {
    stop('Element ids is required')
  }

  if (is.null(start_date)) {
    stop('start_date is required')
  }

  level <- match.arg(level)

  if (is.null(organisations)) {
    organisations <- get_organisation_units()
  }
  organisations <- .get_organisation_units_by_level(organisations, level)

  if (is.null(categories)) {
    categories <- get_categories()
  }

  if (is.null(elements)) {
    elements <- get_data_elements(element_ids)
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
                  khis_session = khis_session
  )

  if (is.null(data$rows) || length(data$rows) == 0) {
    stop('No data was retrieved')
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
