
#' Get the target population for cervical cancer screening in Kenya
#'
#' \code{cervical_target_population} function subsets the Kenyan population and
#' creates a target population for cervical cancer screening: females aged
#' between 25 years and 50 years
#'
#' @param year Year for which to estimate population
#' @param includeSubCounty Whether to include sub county data (default: false)
#' @return A tibble containing the target population for cervical cancer screening
#' \describe{
#'    \item{county}{name of the county}
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

cervical_target_population <- function(year, includeSubCounty = FALSE) {
  age = sex = NULL # due to NSE notes in R CMD check
  year <- case_when(
    year <= 2025 ~ 2025,
    year > 2025 ~ 2030,
  )

  grp <- c('county')
  if (includeSubCounty) {
    grp <- append(grp, 'subcounty')
  }

  n <- year - 2020
  population <- population_data %>%
    filter(sex == 'female', age >= 25, age < 50) %>%
    group_by(across(all_of(grp))) %>%
    summarise(
      target = .population_growth(sum(population, na.rm = TRUE), n) *0.7 /5
    )

  return(population)
}

#' Get the target population for clinical breast examination in Kenya
#'
#' \code{cbe_target_population} function subsets the Kenyan population creates a
#' target population eligible for clinical breast examination: females aged
#' between 25 years and 74 years
#'
#' @param year Year for which to estimate population
#' @param includeSubCounty Whether to include sub county data (default: false)
#' @return A tibble containing the target population for clinical breast
#' examination (CBE)
#' \describe{
#'    \item{county}{name of the county}
#'    \item{target}{number to be screened}
#' }
#'
#' @author David Kariuki
#' @details
#' Implements the \link{breast_target_population} with the min_age set at 25 and
#' max_age at 75 as guided by the Kenya National Cancer Screening Guideline 2018
#'
#' @export

cbe_target_population <- function(year, includeSubCounty = FALSE) {
  population <- breast_target_population(year, min_age = 25, max_age = 75, includeSubCounty = includeSubCounty)
  return(population)
}

#' Get the target population for breast cancer screening through mammography
#'
#' \code{mammo_target_population} subsets the Kenyan population and creates a
#' target population eligible for breast cancer screening through mammography:
#' females aged between 40 years to 74 years
#'
#' @param year Year for which to estimate population
#' @param includeSubCounty Whether to include sub county data (default: false)
#' @return A tibble containing the target population eligible for breast cancer
#' screening through mammography
#' \describe{
#'    \item{county}{name of the county}
#'    \item{target}{number to be screened}
#' }
#'
#' @author David Kariuki
#' @details
#' Implements the \link{breast_target_population} with the min_age set at 40 and
#' max_age at 75 as guided by the Kenya National Cancer Screening Guideline 2018
#'
#' @export

mammogram_target_population <- function(year, includeSubCounty = FALSE) {
  population <- breast_target_population(year, min_age = 40, max_age = 75, includeSubCounty = includeSubCounty)
  return(population)
}

#' Get the target population for breast cancer screening
#'
#' \code{breast_target_population} subsets the Kenyan population produced by  and
#' creates a target population eligible for breast cancer screening
#'
#' @param year Year for which to estimate population
#' @param min_age The minimum age to be in the population
#' @param max_age The maximum age to be in the population (not included)
#' @param includeSubCounty Whether to include sub county data (default: false)
#' @return A tibble containing the target population eligible for breast cancer screening
#' \describe{
#'    \item{county}{name of the county}
#'    \item{target}{number to be screened}
#' }
#'
#' @details
#' Breast cancer screening target population based on Kenya National Cancer Screening
#' guidelines 2018. Annual targets increase from 5% in 2021 to 42% in 2030.
#'
#' @export

breast_target_population <- function(year, min_age, max_age = 75, includeSubCounty = FALSE) {
  age = sex = NULL # due to NSE notes in R CMD check
  year <- case_when(
    year < 2021 ~ 2021,
    year > 2030 ~ 2030,
    .default = year
  )

  n <- year - 2020
  breast_target_percent <- c(
    '2021' = 0.05, '2022' = 0.08, '2023' = 0.10,
    '2024' = 0.15, '2025' = 0.20, '2026' = 0.25,
    '2027' = 0.30, '2028' = 0.33, '2029' = 0.37, '2030' = 0.42
  )
  grp <- c('county')
  if (includeSubCounty) {
    grp <- append(grp, 'subcounty')
  }

  population <- population_data %>%
    filter(sex == 'female', age >= min_age, age < max_age)%>%
    group_by(across(all_of(grp))) %>%
    summarise(
      target = .population_growth(sum(population, na.rm = TRUE), n) * breast_target_percent[toString(year)]
    )

  return(population)
}

#' Projects population growth
#'
#' \code{.population_growth} function projects population growth based on the formula
#' \code{Nt = P * e^(r * t)}. The annual population growth rate, r, is set at 2.2% and
#' the years,t, calculated with the reference to the year 2020 year after the last
#' population census
#'
#' @param P Initial population size
#' @param year Year for which to estimate population
#' @param rate Annual growth rate
#' @return Projected population size at the specified year
#'
#' @noRd

.population_growth <- function(P, year, rate = 0.022) {
  val <- P * floor(exp(rate * year) * 100) / 100
  return(val)
}
