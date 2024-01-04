#' Filters Organisation Units by Level
#'
#' `.filter_organisation_units()` filters a tibble of organisation units
#'   to include only the specified level of the hierarchy, preparing it for merging
#'   with analytics data.
#'
#' @param orgs A tibble of organisation units, typically obtained from [get_organisation_units_metadata()].
#' @param level The desired level of the hierarchy to include, as a character string: `"kenya"`, `"county"`, `"subcounty"`, `"ward"`, or `"facility"`.
#'
#' @return A tibble containing the filtered organisation units, with columns:
#' * org_id: The ID of the organisation unit at the specified level.
#' * county: The name of the county.
#' * subcounty (optional): The name of the subcounty.
#' * ward (optional): The name of the ward.
#' * facility (optional): The name of the facility.
#'
#' @noRd

.filter_organisation_units <- function(orgs, level =c('kenya', 'county', 'subcounty', 'ward', 'facility')) {
  org_id = kenya = county = subcounty = ward = facility = NULL # due to NSE notes in R CMD check
  level <- arg_match(level)

  col <- sym(str_c(level, '_id'))
  orgs <- orgs %>%
    distinct(!!col, .keep_all = TRUE) %>%
    rename(org_id = !!col)

  orgs <- switch (level,
                  kenya = orgs %>% select(org_id, kenya),
                  county = orgs %>% select(org_id, county),
                  subcounty = orgs %>% select(org_id, county, subcounty),
                  ward = orgs %>% select(org_id, county, subcounty, ward),
                  facility = orgs %>% select(org_id, county, subcounty, ward, facility),
  )

  return(orgs)
}
