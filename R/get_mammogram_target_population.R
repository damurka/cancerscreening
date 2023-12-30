#' Get the target population for breast cancer screening through mammography
#'
#' \code{get_mammogram_target_population} subsets the Kenyan population and creates a
#' target population eligible for breast cancer screening through mammography:
#' females aged between 40 years to 74 years
#'
#' @param year Year for which to estimate population
#' @param level The desired level of the organization unit hierarchy to retrieve data for: "kenya", "county" or "subcounty".
#' @return A tibble containing the target population eligible for breast cancer
#' \describe{
#'    \item{kenya}{name of the country}
#'    \item{county}{name of the county}
#'    \item{subcounty}{name of the county}
#'    \item{target}{number to be screened}
#' }
#'
#' @details
#' Implements the age group population with the min_age set at 40 and max_age at
#' 75 as guided by the Kenya National Cancer Screening Guideline 2018
#'
#' @export

get_mammogram_target_population <- function(year, level = c('kenya', 'county', 'subcounty')) {
  population <- .get_breast_target_population(year, min_age = 40, max_age = 75, level = level)
  return(population)
}

