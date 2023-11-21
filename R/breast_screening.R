
#' Retrieves breast cancer screening data
#'
#' \code{get_breast_data} function retrieves breast cancer screening data for a specified period
#'  using the \link{get_analytics} function.
#'
#' @param element_ids A vector with the list of data element  to retrieve data
#' @param start_date The start date for the data retrieval in the format 'YYYY-MM-dd'
#' @param end_date The end date for the data retrieval in the format 'YYYY-MM-dd'. The default is to get the current date
#' @param categories The list of categories. The default action is download using \link{get_categories}
#' @param facilities The list of facilities. The default action is download using \link{get_facilities}
#' @param elements The list of data elements. The default action is download using \link{get_data_elements}
#' @param d2_session the khisSession object, default is "d2_default_session",
#' it will be made upon logining in to KHIS with \link{loginToKHIS}
#' @return A tibble containing breast cancer screening data
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

get_breast_data <- function(element_ids,
                            start_date,
                            end_date = NULL,
                            categories = NULL,
                            facilities = NULL,
                            elements = NULL,
                            d2_session = dynGet("d2_default_session", inherits = TRUE)) {

  data <- get_analytics(
    element_ids,
    start_date,
    end_date,
    facilities,
    elements,
    categories,
    d2_session = d2_session
    ) %>%
    mutate(
      category = factor(category, levels = c('25-34 yrs', '35-39 yrs', '40-55 yrs', '56-74 yrs', '>75 yrs'))
    )
  return(data)
}

#' Retrieves data for clinical breast examination (CBE) conducted
#'
#' \code{get_cbe_conducted} function retrieves data for CBE conducted within a specified
#' period using the \link{get_breast_data} function.
#'
#' @param start_date The start date for the data retrieval in the format 'YYYY-MM-dd'
#' @param end_date The end date for the data retrieval in the format 'YYYY-MM-dd'. The default is to get the current date
#' @param categories The list of categories. The default action is download using \link{get_categories}
#' @param facilities The list of facilities. The default action is download using \link{get_facilities}
#' @param elements The list of data elements. The default action is download using \link{get_data_elements}
#' @param d2_session the khisSession object, default is "d2_default_session",
#' it will be made upon logining in to KHIS with \link{loginToKHIS}
#' @return A tibble containing a list of clinical breast examinations conducted
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

get_cbe_conducted <- function(start_date,
                              end_date = NULL,
                              categories = NULL,
                              facilities = NULL,
                              elements = NULL,
                              d2_session = dynGet("d2_default_session", inherits = TRUE)) {

  # Clinical Breast Examination data elements
  # XEX93uLsAm2 = CBE Abnormal
  # cXe64Yk0QMY = CBE Normal
  cbe_element_ids <- c('cXe64Yk0QMY', 'XEX93uLsAm2')

  data <- get_breast_data(cbe_element_ids, start_date, end_date, categories, facilities, elements, d2_session = d2_session)

  return(data)
}

#' Retrieves data for mammogram conducted
#'
#' \code{get_data_elements} function retrieves data for mammograms conducted within a
#'  specified period using the \link{get_breast_data} function.
#'
#' @param start_date The start date for the data retrieval in the format 'YYYY-MM-dd'
#' @param end_date The end date for the data retrieval in the format 'YYYY-MM-dd'. The default is to get the current date
#' @param categories The list of categories. The default action is download using \link{get_categories}
#' @param facilities The list of facilities. The default action is download using \link{get_facilities}
#' @param elements The list of data elements. The default action is download using \link{get_data_elements}
#' @param d2_session the khisSession object, default is "d2_default_session",
#' it will be made upon logining in to KHIS with \link{loginToKHIS}
#' @return A tibble containing a list of mammograms conducted
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

get_mammogram_screened <- function(start_date,
                                   end_date = NULL,
                                   categories = NULL,
                                   facilities = NULL,
                                   elements = NULL,
                                   d2_session = dynGet("d2_default_session", inherits = TRUE)) {

  # Mammogram screening element ids
  # T3crNg5D3Xa = Mammogram - BIRADS-0 to 3
  # Sorvgq7NDug = Mammogram - BIRADS-4
  # bi1ipJR6zNJ = Mammogram - BIRADS-5
  # APhWHU4KLWF = Mammogram - BIRADS-6
  mammogram_element_ids <- c('T3crNg5D3Xa', 'Sorvgq7NDug', 'bi1ipJR6zNJ', 'APhWHU4KLWF')

  data <- get_breast_data(mammogram_element_ids, start_date, end_date, categories, facilities, elements, d2_session = d2_session)

  return(data)
}
