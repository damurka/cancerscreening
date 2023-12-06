
#' Make an API call to the Kenya Health Information System (KHIS) server
#'
#' \code{api_get} function makes an API call to the KHIS server
#'
#' @param url_path The path to make an api call
#' @param d2_session the d2Session object, default is "d2_default_session",
#' @param ... Name-value pairs that provide query parameters. Each value must be
#'     either a length-1 atomic vector (which is automatically escaped) or NULL (which
#'     is silently dropped).
#' @param retry number of times to try in case of failure,.
#' @param verbosity How much information to print?
#'     - 0: no output
#'     - 1: show headers
#'     - 2: show headers and bodies
#'     - 3: show headers, bodies and curl status message
#' @return Parsed JSON
#'
#' @export
#'
api_get <- function(url_path, d2_session, ..., retry = 1, verbosity = 0) {

  username <- d2_session$username
  if (is.null(username)) {
    stop("You are not logged into KHIS")
  }

  params <- list(
    ...,
    outputIdScheme='NAME',
    showHierarchy = TRUE,
    paging = FALSE,
    skipData = FALSE,
    skipMeta = TRUE,
    ignoreLimit = TRUE
  )

  credentials <- getCredentialsFromKeyring(username = username)

  resp <- request('https://hiskenya.org/api') %>%
    req_url_path_append(url_path) %>%
    req_url_query(!!!params) %>%
    req_retry(max_tries = retry) %>%
    req_user_agent('') %>%
    req_auth_basic(username, credentials['password']) %>%
    req_perform(verbosity = verbosity) %>%
    resp_body_json()

  return(resp)
}

#' Get list of health facilities in Kenya
#'
#' \code{get_facilities} function retrieves a list of health facilities or organisation
#' units using the \link{api_get} function. The organisation unit only filters for
#' health facilities only
#'
#' @param d2_session the khisSession object, default is "d2_default_session"
#' @return A tibble containing a list of health facilities in Kenya
#' \describe{
#'    \item{facility_id}{organisation identifier that uniquely identifies the health facility}
#'    \item{facility}{name of the health facility}
#'    \item{county}{name of the county}
#'    \item{subcounty}{name of the subcounty}
#'    \item{ward}{name of the ward}
#' }
#'
#' @export

get_facilities <- function(d2_session = dynGet("d2_default_session", inherits = TRUE)) {

  orgs <- api_get('organisationUnits',
                 fields='id,name,path', d2_session = d2_session)

  orgs <- tibble(x = orgs$organisationUnits) %>%
    unnest_wider(x)

  orgs[c('no_data', 'kenya_id', 'county_id', 'subcounty_id', 'ward_id', 'facility_id', 'community_id')] <- str_split_fixed(orgs$path, '/', 7)

  orgs <- orgs%>%
    filter(!is.na(facility_id)) %>%
    rename(facility = name) %>%
    left_join(orgs %>% select(id, name) %>% rename(ward = name), by=c('ward_id'='id')) %>%
    left_join(orgs %>% select(id, name) %>% rename(subcounty = name), by=c('subcounty_id'='id')) %>%
    left_join(orgs %>% select(id, name) %>% rename(county = name), by=c('county_id'='id')) %>%
    select(facility_id, facility, county, subcounty, ward) %>%
    distinct(facility_id, .keep_all = TRUE) %>%
    mutate(
      county = factor(str_remove(county, ' County')),
      subcounty = factor(str_remove(subcounty, ' Sub County')),
      ward = factor(str_remove(ward, ' Ward'))
    )

  return(orgs)
}

#' Get list of category options metadata
#'
#' \code{get_categories} function retrieves a list of category options using the
#' \link{api_get} function.
#'
#' @param d2_session the khisSession object, default is "d2_default_session"
#' @return A tibble containing a list of category options
#' \describe{
#'    \item{category_id}{unique identifier for the category option}
#'    \item{category}{name of the category option}
#' }
#'
#' @export

get_categories <- function(d2_session = dynGet("d2_default_session", inherits = TRUE)) {

  cat_group <- api_get('categoryOptions', d2_session = d2_session, fields='id,name,categoryOptionCombos')

  cat_group <- tibble(x = cat_group$categoryOptions) %>%
    unnest_wider(x) %>%
    unnest_longer(categoryOptionCombos) %>%
    unnest_longer(categoryOptionCombos) %>%
    rename(
      category_id = categoryOptionCombos,
      category = name
    ) %>%
    select(category_id, category)

  return(cat_group)
}

#' Get list of data elements metadata
#'
#' \code{get_data_elements} function retrieves a list of data elements using the
#' \link{api_get} function.
#'
#' @param d2_session the khisSession object, default is "d2_default_session",
#' @return A tibble containing a list of data elements
#' \describe{
#'    \item{element_id}{unique identifier for the data element}
#'    \item{element}{name of the data element}
#' }
#'
#' @export

get_data_elements <-function(d2_session = dynGet("d2_default_session", inherits = TRUE)) {

  data <- api_get('dataElements', d2_session = d2_session, fields='id,name')
  data <- tibble(x = data$dataElements) %>%
    unnest_wider(x) %>%
    rename(
      element_id = id,
      element = name
    )

  return(data)
}

#' Retrieves data for specified data elements
#'
#' \code{get_data_elements} function retrieves data for a specified period and data element
#'  using the \link{api_get} function. It returns the data stored in the analytics data tables
#'  without any aggregation being performed.
#'
#' @param element_ids A vector with the list of data element  to retrieve data
#' @param start_date The start date for the data retrieval in the format 'YYYY-MM-dd'
#' @param end_date The end date for the data retrieval in the format 'YYYY-MM-dd'. The default is to get the current date
#' @param elements The list of data elements. The default action is download using \link{get_data_elements}
#' @param categories The list of categories. The default action is download using \link{get_categories}
#' @param d2_session the khisSession object, default is "d2_default_session",
#' it will be made upon logining in to KHIS with \link{loginToKHIS}
#' @return A tibble containing a list of data elements
#' \describe{
#'    \item{facility_id}{organisation identifier that uniquely identifies the health facility}
#'    \item{facility}{name of the health facility}
#'    \item{facility_type}{The type of the facility: Dispensary, health centre, medical clinic etc.}
#'    \item{facility_ownership}{facility ownership: faith based, private or governement}
#'    \item{keph_level}{facility level}
#'    \item{county}{name of the county}
#'    \item{subcounty}{name of the subcounty}
#'    \item{month}{name of the month reported}
#'    \item{year}{the year of the report}
#'    \item{fiscal_year}{the financial year of the report. uses July - June Cycle}
#'    \item{category}{name of the category option}
#'    \item{element}{name of the data element}
#'    \item{source}{source document of the report}
#'    \item{element}{name of the data element}
#'    \item{period}{the month of the report}
#'    \item{value}{The numeric value for the number of cases reported}
#' }
#'
#' @export

get_analytics <-function(element_ids,
                         start_date,
                         end_date = NULL,
                         #facilities = NULL,
                         elements = NULL,
                         categories = NULL,
                         d2_session = dynGet("d2_default_session", inherits = TRUE)) {

  if (!is.vector(element_ids) || length(element_ids) == 0) {
    stop('Element is required')
  }

  #if(is.null(facilities) || length(facilities) == 0) {
  #  facilities = get_facilities()
  #}

  if(is.null(elements) || length(elements) == 0) {
    elements = get_data_elements()
  }

  if(is.null(categories) || length(categories) == 0) {
    categories = get_categories()
  }

  if (is.null(end_date)) {
    end_date = today()
  }

  dx <- str_c(element_ids, collapse = ';')
  dx <- str_c('dx', dx, sep = ':')
  data <- api_get(c('analytics', 'rawData.json'),
                  d2_session = d2_session,
                 dimension=dx,
                 dimension='JlW9OiK1eR4', # Facility ownership dimension
                 dimension='sytI3XYbxwE', # KEPH level dimension
                 dimension='FSoqQFDES0U', # Facility type dimension
                 dimension = 'co',
                 dimension = 'ou:USER_ORGUNIT',
                 startDate =start_date,
                 endDate = end_date,
                 skipData = FALSE,
                 skipMeta = TRUE,
                 ignoreLimit = TRUE)

  data <- tibble(x = data$rows) %>%
    unnest_wider(x, ',')

  colnames(data) <- c('element_id', 'category_id', 'ownership_id', 'keph_id', 'type_id', 'facility_id', 'period', 'country', 'county', 'subcounty', 'ward', 'facility', 'community_unit', 'period_start', 'period_end', 'value')

  data <- data %>%
    left_join(elements, by='element_id') %>%
    left_join(get_facility_types(), by='type_id') %>%
    left_join(get_keph_levels(), by='keph_id') %>%
    left_join(get_facility_ownerships(), by='ownership_id') %>%
    #left_join(facilities, by='facility_id') %>%
    left_join(categories, by='category_id', relationship='many-to-many') %>%
    mutate(
      value = as.integer(value),
      period = ym(period),
      month = month(period, label=TRUE, abbr = FALSE),
      year = as.integer(year(period)),
      year_f = as.integer(quarter(period, fiscal_start = 7, type='year.quarter')),
      fiscal_year = factor(str_c(ifelse(year_f == year, year-1, year), year_f, sep = '/'))
    ) %>%
    select(-period_start, -period_end, -year_f, -type_id, -keph_id, -ownership_id, -element_id)

  return(data)
}

#' Get the facility ownership metadata
#'
#' \code{get_facility_ownerships} function retrieves the facility ownership metadata
#'
#' @return A tibble containing a list of facility ownership metadata
#' \describe{
#'    \item{ownership_id}{unique identifier for the data element}
#'    \item{facility_ownership}{name of the data element}
#' }
#'
#' @export

get_facility_ownerships <- function() {
  ## ORGANISATION_UNIT_GROUP
  ## JlW9OiK1eR4 - Facility Ownership
  # eT1vvFVhLHc - Faith Based Organisation
  # AaAF5EmS1fk - Ministry of Health
  # aRxa6o8GqZN - Private
  # facility_ownership <- 'JlW9OiK1eR4:eT1vvFVhLHc;AaAF5EmS1fk;aRxa6o8GqZN'

  tibble(
    ownership_id = c('eT1vvFVhLHc', 'AaAF5EmS1fk', 'aRxa6o8GqZN'),
    facility_ownership = c('Faith Based Organisation', 'Ministry of Health', 'Private')
  )
}

#' Get the facility Kenya essential package for Health (KEPH) level metadata
#'
#' \code{get_keph_levels} function retrieves the facility KEPH level metadata
#'
#' @return A tibble containing a list of facility KEPH level metadata
#' \describe{
#'    \item{keph_id}{unique identifier for the data element}
#'    \item{keph_level}{name of the data element}
#' }
#'
#' @export

get_keph_levels <- function() {
  ## ORGANISATION_UNIT_GROUP
  ## sytI3XYbxwE - KEPH Level
  # axUnguN4QDh - KEPH Level 1
  # tvMxZ8aCVou - KEPH Level 2
  # wwiu1jyZOXO - KEPH Level 3
  # hBZ5DRto7iF - KEPH Level 4
  # d5QX71PY5t0 - KEPH Level 5
  # FpY8vg4gh46 - KEPH Level 6
  # keph_level <- 'sytI3XYbxwE:axUnguN4QDh;tvMxZ8aCVou;wwiu1jyZOXO;hBZ5DRto7iF;d5QX71PY5t0;FpY8vg4gh46'

  tibble(
    keph_id = c('axUnguN4QDh', 'tvMxZ8aCVou', 'wwiu1jyZOXO', 'hBZ5DRto7iF', 'd5QX71PY5t0', 'FpY8vg4gh46'),
    keph_level = c('Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5', 'Level 6')
  )
}

#' Get the facility type metadata
#'
#' \code{get_facility_types} function retrieves the facility type metadata
#'
#' @return A tibble containing a list of facility type metadata
#' \describe{
#'    \item{type_id}{unique identifier for the data element}
#'    \item{facility_type}{name of the data element}
#' }
#'
#' @export

get_facility_types <- function() {

  ## ORGANISATION_UNIT_GROUP
  ## FSoqQFDES0U - Facility Type
  # mVrepdLAqSD - Revised Dispensary (2018)
  # rhKJPLo27x7 - Revised Health Centre (2018)
  # CGDNIWGHRNr - Revised Hospital (2018)
  # xKv918PvmHN - Revised Medical Center (2018)
  # lTrpyOiOcM6 - Revised Medical Clinic (2018)
  # lQXBYwznvXA - Revised Nursing Home (2018)
  # YQK9pleIoeB - Revised Stand alone(2018)
  # facility_type <- 'FSoqQFDES0U:mVrepdLAqSD;rhKJPLo27x7;CGDNIWGHRNr;xKv918PvmHN;lTrpyOiOcM6;lQXBYwznvXA;YQK9pleIoeB'

  tibble(
    type_id = c('mVrepdLAqSD','rhKJPLo27x7','CGDNIWGHRNr','xKv918PvmHN','lTrpyOiOcM6','lQXBYwznvXA','YQK9pleIoeB'),
    facility_type = c('Dispensary','Health Centre','Hospital','Medical Centre','Medical Clinic','Nursing Home','Stand alone')
  )
}
