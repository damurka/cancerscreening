
#' Retrieves cervical cancer screen and treatment data
#'
#' \code{get_cervical_data} function retrieves cervical cancer screening and treatment
#'  data for a specified period using the \link{get_analytics} function.
#'
#' @param element_ids A vector with the list of data element  to retrieve data
#' @param start_date The start date for the data retrieval in the format 'YYYY-MM-dd'
#' @param end_date The end date for the data retrieval in the format 'YYYY-MM-dd'. The default is to get the current date
#' @param categories The list of categories. The default action is download using \link{get_categories}
#' @param facilities The list of facilities. The default action is download using \link{get_facilities}
#' @param elements The list of data elements. The default action is download using \link{get_data_elements}
#' @param d2_session the khisSession object, default is "d2_default_session",
#' it will be made upon logining in to KHIS with \link{loginToKHIS}
#' @return A tibble containing cervical screening and treatment data
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

get_cervical_data <- function(element_ids,
                              start_date,
                              end_date = NULL,
                              categories = NULL,
                              facilities = NULL,
                              elements = NULL,
                              d2_session = dynGet("d2_default_session", inherits = TRUE)) {

  data <- get_analytics(element_ids,
                        start_date,
                        end_date,
                        facilities,
                        elements,
                        categories,
                        d2_session = d2_session
                        ) %>%
    filter(str_detect(category, '[1-9]')) %>%
    mutate(
      category = case_when(
        str_detect(category, '<25') ~ '<25',
        str_detect(category, '25-49') ~ '25-49',
        .default = '50+',
        .ptype = factor(levels = c('<25', '25-49', '50+'))
      ),
      source = case_when(
        str_detect(element, 'MOH 711') ~ 'MOH 711',
        .default = 'MOH 745',
        .ptype = factor(levels = c('MOH 711', 'MOH 745'))
      )
    )

  return(data)
}

#' Retrieves cervical cancer screening data
#'
#' \code{get_cervical_screened} function retrieves cervical cancer screening data for a specified period
#'  using the \link{get_cervical_data} function.
#'
#' @param start_date The start date for the data retrieval in the format 'YYYY-MM-dd'
#' @param end_date The end date for the data retrieval in the format 'YYYY-MM-dd'. The default is to get the current date
#' @param categories The list of categories. The default action is download using \link{get_categories}
#' @param facilities The list of facilities. The default action is download using \link{get_facilities}
#' @param elements The list of data elements. The default action is download using \link{get_data_elements}
#' @param d2_session the khisSession object, default is "d2_default_session",
#' it will be made upon logining in to KHIS with \link{loginToKHIS}
#' @return A tibble containing cervical cancer screening data
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

get_cervical_screened <- function(start_date,
                                  end_date = NULL,
                                  categories = NULL,
                                  facilities = NULL,
                                  elements = NULL,
                                  d2_session = dynGet("d2_default_session", inherits = TRUE)) {

  ## Cervical Cancer Screening
  # VR7vdS7P0Gb = Number of clients who received HPV Test
  # gQro1y7Rsbq = Number of clients who received Pap smear
  # rFtB3keaVWm = Number of clients who received VIA or VIA/ VILI Screening
  # ommbnTANmGo = MOH 711 Clients screened for Cervical Cancer using HPV test
  # kl4RvWOGb7x = MOH 711 Clients screened  using Pap smear
  # G9COyloYLYa = MOH 711 Clients screened using VIA /VILI /HPV VILI / HPV
  cacx_screening_ids <- c(
    'VR7vdS7P0Gb', 'gQro1y7Rsbq', 'rFtB3keaVWm',
    'ommbnTANmGo', 'kl4RvWOGb7x', 'G9COyloYLYa'
  )

  data <- get_cervical_data(cacx_screening_ids, start_date, end_date, categories, facilities, elements, d2_session = d2_session) %>%
    mutate(
      element = case_when(
        str_detect(element, 'VIA') ~ 'VIA',
        str_detect(element, 'HPV') ~ 'HPV',
        str_detect(element, 'Pap') ~'Pap Smear',
        .ptype = factor(levels = c('VIA', 'HPV', 'Pap Smear'))
      )
    )

  return(data)
}

#' Retrieves cervical cancer screening data on HIV positive women
#'
#' \code{get_cervical_hiv_screened} function retrieves cervical cancer screening data
#' for HIV positive women for a specified period using the \link{get_cervical_data} function.
#'
#' @param start_date The start date for the data retrieval in the format 'YYYY-MM-dd'
#' @param end_date The end date for the data retrieval in the format 'YYYY-MM-dd'. The default is to get the current date
#' @param categories The list of categories. The default action is download using \link{get_categories}
#' @param facilities The list of facilities. The default action is download using \link{get_facilities}
#' @param elements The list of data elements. The default action is download using \link{get_data_elements}
#' @param d2_session the khisSession object, default is "d2_default_session",
#' it will be made upon logining in to KHIS with \link{loginToKHIS}
#' @return A tibble containing cervical cancer screening data  on HIV positive women
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

get_cervical_hiv_screened <- function(start_date,
                                      end_date = NULL,
                                      categories = NULL,
                                      facilities = NULL,
                                      elements = NULL,
                                      d2_session = dynGet("d2_default_session", inherits = TRUE)) {

  ## Cervical Cancer Screening to HIV positive women
  # htFuvGJRW1X = Number of HIV positive clients screened
  # joXHDIBe8I2 = Number of HIV positive with positive screening results
  # n8Z1XFaeS1t = MOH 711 HIV positive clients screened for cervical cancer
  cacx_hiv_screening_ids <- c('htFuvGJRW1X', 'joXHDIBe8I2', 'n8Z1XFaeS1t')

  data <- get_cervical_data(cacx_hiv_screening_ids, start_date, end_date, categories, facilities, elements, d2_session = d2_session) %>%
    mutate(
      element = factor(ifelse(str_detect(element, 'screened'), 'Screened', 'Positive'))
    )

  return(data)
}

#' Retrieves cervical cancer screening data with positive results
#'
#' \code{get_cervical_positive} function retrieves cervical cancer screening data
#' with positive screening result for a specified period using the \link{get_cervical_data} function.
#'
#' @param start_date The start date for the data retrieval in the format 'YYYY-MM-dd'
#' @param end_date The end date for the data retrieval in the format 'YYYY-MM-dd'. The default is to get the current date
#' @param categories The list of categories. The default action is download using \link{get_categories}
#' @param facilities The list of facilities. The default action is download using \link{get_facilities}
#' @param elements The list of data elements. The default action is download using \link{get_data_elements}
#' @param d2_session the khisSession object, default is "d2_default_session",
#' it will be made upon logining in to KHIS with \link{loginToKHIS}
#' @return A tibble containing cervical cancer screening data with positive screening results
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

get_cervical_positive <- function(start_date,
                                  end_date = NULL,
                                  categories = NULL,
                                  facilities = NULL,
                                  elements = NULL,
                                  d2_session = dynGet("d2_default_session", inherits = TRUE)) {

  # wYHt86csbhn = Number of clients with Positive Cytology result
  # KLQZDP0ycOY = Number of clients with Positive HPV result
  # xBjAMa2KFwD = Number of clients with Positive VIA or VIA/VILI result
  # La4v1gAs5cp = Number of clients with suspicious cancer lesions
  # xbERCTpWTwi = MOH 711 Cervical cancer clients with Positive Cytology result
  # LI2g0vO0xvx = MOH 711 Cervical cancer clients with Positive HPV result
  # dBdw7Inlq2C = MOH 711 Cervical cancer clients with Positive VIA/VILI result
  # FC5BbFDsdCa = MOH 711 Clients with suspicious cancer lesion
  cacx_positive_ids <- c(
    'wYHt86csbhn', 'KLQZDP0ycOY', 'xBjAMa2KFwD', 'La4v1gAs5cp',
    'xbERCTpWTwi', 'LI2g0vO0xvx', 'dBdw7Inlq2C', 'FC5BbFDsdCa'
  )

  data <- get_cervical_data(cacx_positive_ids, start_date, end_date, categories, facilities, elements, d2_session = d2_session) %>%
    mutate(
      element = case_when(
        str_detect(element, 'VIA') ~ 'VIA',
        str_detect(element, 'HPV') ~ 'HPV',
        str_detect(element, 'Cytology') ~'Pap Smear',
        .default = 'Suspicious Lesion',
        .ptype = factor(levels = c('VIA', 'HPV', 'Pap Smear', 'Suspicious Lesion'))
      )
    )

  return(data)
}

#' Retrieves cervical cancer precancerous treatment data
#'
#' \code{get_cervical_treated} function retrieves cervical cancer precancerous treatment data
#' for a specified period using the \link{get_cervical_data} function.
#'
#' @param start_date The start date for the data retrieval in the format 'YYYY-MM-dd'
#' @param end_date The end date for the data retrieval in the format 'YYYY-MM-dd'. The default is to get the current date
#' @param categories The list of categories. The default action is download using \link{get_categories}
#' @param facilities The list of facilities. The default action is download using \link{get_facilities}
#' @param elements The list of data elements. The default action is download using \link{get_data_elements}
#' @param d2_session the khisSession object, default is "d2_default_session",
#' it will be made upon logining in to KHIS with \link{loginToKHIS}
#' @return A tibble containing cervical cancer precancerous treatment data
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

get_cervical_treated <- function(start_date,
                                 end_date = NULL,
                                 categories = NULL,
                                 facilities = NULL,
                                 elements = NULL,
                                 d2_session = dynGet("d2_default_session", inherits = TRUE)) {

  # Yv6LiN65lCJ = Number of clients treated using Cryotherapy
  # uXi8AjF8YR0 = Number of clients treated using LEEP
  # MIQ3HgFlHnS = Number of clients treated using Thermocoagulation
  # lx4fx2bluTm = Number of other treatment given (e.g. Hysterectomy, cone biopsy)
  # UAbmyzuI2UE = MOH 711 Cervical cancer clients treated using Cryotherapy
  # TSlyElHZw9d = MOH 711 Cervical cancer treated using LEEP
  cacx_treatment_ids <- c(
    'Yv6LiN65lCJ', 'uXi8AjF8YR0', 'MIQ3HgFlHnS', 'lx4fx2bluTm',
    'UAbmyzuI2UE', 'TSlyElHZw9d'
  )

  data <- get_cervical_data(cacx_treatment_ids, start_date, end_date, categories, facilities, elements, d2_session = d2_session) %>%
    mutate(
      element = case_when(
        str_detect(element, 'LEEP') ~ 'LEEP',
        str_detect(element, 'Cryotherapy') ~ 'Cryotherapy',
        str_detect(element, 'Thermocoagulation') ~ 'Thermoablation',
        .default = 'Other',
        .ptype = factor(levels = c('Cryotherapy', 'Thermoablation', 'LEEP', 'Other'))
      )
    )

  return(data)
}
