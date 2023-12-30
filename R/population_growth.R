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
