#' Population Data from KNBS Census
#'
#' Provides population statistics for counties and subcounties in Kenya, as per Volume 3 of the KNBS population census.
#'
#' @details
#' This dataset includes:
#' \itemize{
#'   \item County names
#'   \item Subcounty names
#'   \item Total population counts
#'   \item ... (List other relevant variables, e.g., age groups, gender, etc.)
#' }
#'
#' @format A tibble with 54 rows and 4 variables:
#' \describe{
#'   \item{county}{Character vector of county names.}
#'   \item{subcounty}{Character vector of subcounty names.}
#'   \item{population}{Numeric vector of total population counts.}
#'   \item{...}{(List other variables and their descriptions.)}
#' }
#'
#' @source
#' Kenya National Bureau of Statistics (KNBS), 2019 Kenya Population and Housing Census Volume III
#' \url{https://www.knbs.or.ke/download/2019-kenya-population-and-housing-census-volume-iii-distribution-of-population-by-age-sex-and-administrative-units/}
#'
#' @keywords internal
"population_data"
