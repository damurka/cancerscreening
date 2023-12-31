#' Get Cervical Cancer Screening Target Population
#'
#' `get_cervical_target_population()` subsets the Kenyan population and creates
#' a target population for cervical cancer screening: females aged between 25
#' years and 50 years
#'
#' @param year Year for which to estimate population
#' @param level The desired level of the organization unit hierarchy to retrieve
#'   data for: `"kenya"` (default) , `"county"` or `"subcounty"`.
#' @return A tibble containing the target population for cervical cancer
#'   screening
#'
#' * county     - name of the county. Optional if the level is county or subcounty
#' * subcounty  - name of the county. Optional if the level if subcounty
#' * target     - number to be screened
#'
#' @details The target population for cervical cancer screening is determined by
#' the Kenya National Cancer Screening guidelines 2018 and follows the guidance
#' outlined in the WHO publication 'Planning and implementing cervical cancer
#' prevention programs: A manual for managers.' The annual screening targets for
#' counties and the national level are calculated based on population growth
#'
#' @export
#'
#' @examples
#' # Get the country projection for cervical cancer screening for the year 2024
#' target_population <- get_breast_mammogram_target_population(2024)
#' target_population
#'
#' # Get the projection for cervical cancer screening for 2022 by county
#' target_population <- get_breast_mammogram_target_population(2022, level = 'county')
#' target_population

get_cervical_target_population <- function(year, level = c('kenya', 'county', 'subcounty')) {

  year <- case_when(
    year <= 2025 ~ 2025,
    year > 2025 ~ 2030,
  )

  population <- .get_filtered_population(year, 25, 50, 0.7/5, level)

  return(population)
}

#' Get the Clinical Breast Examination Target Population
#'
#' `get_breast_cbe_target_population()` subsets the Kenyan population creates a
#' target population eligible for clinical breast examination: females aged
#' between 25 years and 74 years
#'
#' @inheritParams get_cervical_target_population
#'
#' @return A tibble containing the target population for clinical breast
#'   examination (CBE)
#'
#' * county     - name of the county. Optional if the level is county or subcounty
#' * subcounty  - name of the county. Optional if the level if subcounty
#' * target     - number to be screened
#'
#' @details Implements age group with the min_age set at 25 and max_age at 75 as
#' guided by the Kenya National Cancer Screening Guideline 2018
#'
#' @export
#'
#' @examples
#' # Get the country projection of women to perform CBE for the year 2024
#' target_population <- get_breast_cbe_target_population(2024)
#' target_population
#'
#' # Get the projection for CBE for 2022 by county
#' target_population <- get_breast_cbe_target_population(2022, level = 'county')
#' target_population

get_breast_cbe_target_population <- function(year, level = c('kenya', 'county', 'subcounty')) {
  population <- .get_breast_target_population(year, min_age = 25, max_age = 75, level = level)
  return(population)
}

#' Get Mammography Target Population
#'
#' `get_breast_mammogram_target_population()` subsets the Kenyan population and
#' creates a target population eligible for breast cancer screening through
#' mammography: females aged between 40 years to 74 years
#'
#' @inheritParams get_cervical_target_population
#'
#' @return A tibble containing the target population eligible for breast cancer
#'
#' * county     - name of the county. Optional if the level is county or subcounty
#' * subcounty  - name of the county. Optional if the level if subcounty
#' * target     - number to be screened
#'
#' @details Implements the age group population with the min_age set at 40 and
#' max_age at 75 as guided by the Kenya National Cancer Screening Guideline 2018
#'
#' @export
#'
#' @examples
#' # Get the country projection of women to perform mammogram for the year 2024
#' target_population <- get_breast_mammogram_target_population(2024)
#' target_population
#'
#' # Get the projection for mammograms for 2022 by county
#' target_population <- get_breast_mammogram_target_population(2022, level = 'county')
#' target_population

get_breast_mammogram_target_population <- function(year, level = c('kenya', 'county', 'subcounty')) {
  population <- .get_breast_target_population(year, min_age = 40, max_age = 75, level = level)
  return(population)
}

#' Get Breast Cancer Screening Target Population
#'
#' `.get_breast_target_population()` subsets the Kenyan population produced by
#' and creates a target population eligible for breast cancer screening
#'
#' @param year Year for which to estimate population
#' @param min_age The minimum age to be in the population
#' @param max_age The maximum age to be in the population (not included)
#' @param level The desired level of the organization unit hierarchy to retrieve
#'   data for: "kenya", "county" or "subcounty".
#'
#' @return A tibble containing the target population eligible for breast cancer
#'   screening
#'
#' * county     - name of the county. Optional if the level is county or subcounty
#' * subcounty  - name of the county. Optional if the level if subcounty
#' * target     - number to be screened
#'
#' @details Breast cancer screening target population based on Kenya National
#' Cancer Screening guidelines 2018. Annual targets increase from 5% in 2021 to
#' 42% in 2030.
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

#' Filters the Population
#'
#' `.get_filtered_population()` filters the population based on age and level
#' and projects the population base on the year provided
#'
#' @param year The year to project the population
#' @param min_age The minimum age to include in the filtered data
#' @param max_age  The maximum age to include in the filtered data
#' @param modifier A multiplier that affect the age projection
#' @param level The desired level of the organization unit hierarchy to retrieve
#'   data for: "kenya", "county" or "subcounty".
#'
#' @return A tibble containing the target population
#'
#' @noRd

.get_filtered_population <- function(year, min_age, max_age, modifier, level = c('kenya', 'county', 'subcounty')) {
  age = sex = NULL # due to NSE notes in R CMD check
  level <- match.arg(level)

  level <- switch (level,
                   kenya = c('kenya'),
                   county = c('county'),
                   subcounty = c('county', 'subcounty'))

  population <- population_data %>%
    filter(sex == 'female', age >= min_age, age < max_age)%>%
    group_by(across(any_of(level))) %>%
    summarise(
      target = .population_growth(sum(population, na.rm = TRUE), year) * modifier
    )

  return(population)
}

#' Projects Population Growth
#'
#' `.population_growth()` function projects population growth based on the formula
#' `Nt = P * e^(r * t)`. The annual population growth rate, `r`, is set at 2.2% and
#' the years,`t`, calculated with the reference to the year 2020 year after the last
#' population census
#'
#' @param P Initial population size
#' @param year Year for which to estimate population
#' @param rate Annual growth rate
#'
#' @return Projected population size at the specified year
#'
#' @noRd

.population_growth <- function(P, year, rate = 0.022) {
  n <- year - 2020
  val <- P * floor(exp(rate * n) * 100) / 100
  return(val)
}
