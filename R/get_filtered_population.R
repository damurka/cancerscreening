#' Filters the population
#'
#' \code{.get_filtered_population} filters the population based on age and level and
#' projects the population base on the year provided
#'
#' @param year The year to project the population
#' @param min_age The minimum age to include in the filtered data
#' @param max_age  The maximum age to include in the filtered data
#' @param modifier A multiplier that affect the age projection
#' @param level The desired level of the organization unit hierarchy to retrieve data for: "kenya", "county" or "subcounty".
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

  n <- year - 2020
  population <- population_data %>%
    filter(sex == 'female', age >= min_age, age < max_age)%>%
    group_by(across(any_of(level))) %>%
    summarise(
      target = .population_growth(sum(population, na.rm = TRUE), n) * modifier
    )

  return(population)
}
