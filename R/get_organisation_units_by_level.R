#' Filters organisation units by level
#'
#' \code{.get_organisation_units_by_level()} filters a tibble of organisation units
#'   to include only the specified level of the hierarchy, preparing it for merging
#'   with analytics data.
#'
#' @param orgs A tibble of organisation units, typically obtained from \code{get_organisation_units()}.
#' @param level The desired level of the hierarchy to include, as a character string: "county", "subcounty", "ward", or "facility".
#'
#' @return A tibble containing the filtered organisation units, with columns:
#' - org_id: The ID of the organisation unit at the specified level.
#' - county: The name of the county.
#' - subcounty (optional): The name of the subcounty.
#' - ward (optional): The name of the ward.
#' - facility (optional): The name of the facility.
#'
#' @noRd

.get_organisation_units_by_level <- function(orgs, level =c('kenya', 'county', 'subcounty', 'ward', 'facility')) {
  level <- match.arg(level)

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
