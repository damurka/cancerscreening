#' Get the target population for clinical breast examination in Kenya
#'
#' \code{get_cbe_target_population} function subsets the Kenyan population creates a
#' target population eligible for clinical breast examination: females aged
#' between 25 years and 74 years
#'
#' @param year Year for which to estimate population
#' @param level The desired level of the organization unit hierarchy to retrieve data for: "kenya", "county" or "subcounty".
#' @return A tibble containing the target population for clinical breast
#' examination (CBE)
#' \describe{
#'    \item{kenya}{name of the country}
#'    \item{county}{name of the county}
#'    \item{subcounty}{name of the county}
#'    \item{target}{number to be screened}
#' }
#'
#' @details
#' Implements age group with the min_age set at 25 and max_age at 75 as guided by
#' the Kenya National Cancer Screening Guideline 2018
#'
#' @export

get_cbe_target_population <- function(year, level = c('kenya', 'county', 'subcounty')) {
  population <- .get_breast_target_population(year, min_age = 25, max_age = 75, level = level)
  return(population)
}
