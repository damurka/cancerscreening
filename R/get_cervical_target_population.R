#' Get the target population for cervical cancer screening in Kenya
#'
#' \code{get_cervical_target_population} function subsets the Kenyan population and
#' creates a target population for cervical cancer screening: females aged
#' between 25 years and 50 years
#'
#' @param year Year for which to estimate population
#' @param level The desired level of the organization unit hierarchy to retrieve data for: "kenya", "county" or "subcounty".
#' @return A tibble containing the target population for cervical cancer screening
#' \describe{
#'    \item{kenya}{name of the country}
#'    \item{county}{name of the county}
#'    \item{subcounty}{name of the county}
#'    \item{target}{number to be screened}
#' }
#'
#' @details
#' The target population for cervical cancer screening is determined by the Kenya
#' National Cancer Screening guidelines 2018 and follows the guidance outlined in
#' the WHO publication 'Planning and implementing cervical cancer prevention programs:
#' A manual for managers.' The annual screening targets for counties and the national
#' level are calculated based on population growth
#'
#' @export

get_cervical_target_population <- function(year, level = c('kenya', 'county', 'subcounty')) {

  year <- case_when(
    year <= 2025 ~ 2025,
    year > 2025 ~ 2030,
  )

  population <- .get_filtered_population(year, 25, 50, 0.7/5, level)

  return(population)
}
