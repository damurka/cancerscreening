#' Get the target population for breast cancer screening
#'
#' \code{.get_breast_target_population} subsets the Kenyan population produced by  and
#' creates a target population eligible for breast cancer screening
#'
#' @param year Year for which to estimate population
#' @param min_age The minimum age to be in the population
#' @param max_age The maximum age to be in the population (not included)
#' @param level The desired level of the organization unit hierarchy to retrieve data for: "kenya", "county" or "subcounty".
#' @return A tibble containing the target population eligible for breast cancer screening
#' \describe{
#'    \item{kenya}{name of the country}
#'    \item{county}{name of the county}
#'    \item{subcounty}{name of the subcounty}
#'    \item{target}{number to be screened}
#' }
#'
#' @details
#' Breast cancer screening target population based on Kenya National Cancer Screening
#' guidelines 2018. Annual targets increase from 5% in 2021 to 42% in 2030.
#'
#' @noRd

.get_breast_target_population <- function(year, min_age, max_age = 75, level = c('kenya', 'county', 'subcounty')) {

  year <- case_when(
    year < 2021 ~ 2021,
    year > 2030 ~ 2030,
    .default = year
  )

  breast_target_percent <- c(
    '2021' = 0.05, '2022' = 0.08, '2023' = 0.10,
    '2024' = 0.15, '2025' = 0.20, '2026' = 0.25,
    '2027' = 0.30, '2028' = 0.33, '2029' = 0.37, '2030' = 0.42
  )

  population <- .get_filtered_population(year, min_age, max_age, breast_target_percent[toString(year)], level)

  return(population)
}
