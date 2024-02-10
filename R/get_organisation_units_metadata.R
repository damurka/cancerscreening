
#' Get Organisation Units Metadata
#'
#' `get_organisation_units_metadata()` fetches organisation units metadata from the
#'   KHIS API server.
#'
#' @param org_ids The organisation identifiers whose details being retrieved
#' @param level The desired data granularity: `"country"` (the default), `"county"`, `"subcounty"`, `"ward"`, or `"facility"`.
#'
#' @return A tibble containing the following columns:
#'
#'  * id            - Organisation identifier that uniquely identifies the organisation by level
#'  * country       - Name of the country
#'  * county        - Name of the county.
#'  * subcounty     - Name of the subcounty.
#'  * ward          - Name of the ward.
#'  * facility      - Name of the health facility.
#'
#' @export
#'
#' @examplesIf khis_has_cred()
#' # Fetch all the organisation units metadata
#' organisations <- get_organisation_units_metadata()
#' organisations

get_organisation_units_metadata <- function(org_ids = NULL,
                                            level =c('country', 'county', 'subcounty', 'ward', 'facility')) {

  parent = county = subcounty = ward = NULL # due to NSE notes in R CMD check

  level <- arg_match(level)

  filter <- splice(list2(filter = NULL))
  if (!is.null(org_ids)) {
    filter <- id %.in% org_ids
  }

  lev <- switch (level,
    country = 1,
    county = 2,
    subcounty = 3,
    ward = 4,
    facility = 5
  )

  orgs <- get_organisation_units(filter,
                                 level %.eq% lev,
                                 fields = 'id,name,parent[name,parent[name, parent[name, parent[name]]]]')

  if (is_empty(orgs)) {
    return (NULL)
  }

  if (level != 'country') {
    col <- switch(level,
                  'facility' = list2(ward = 'name', subcounty = list('parent', 'name'),
                                     county = list('parent', 'parent', 'name')),
                  'ward' = list2(subcounty = 'name', county = list('parent', 'name'),
                                 country = list('parent', 'parent', 'name')),
                  'subcounty' = list2(county = 'name',country = list('parent', 'name')),
                  'county' = list2(country = 'name'),
                  stop("Invalid level"))

    orgs <- orgs %>%
      hoist(parent, splice(col)) %>%
      select(-any_of('parent'))
  }

  orgs <- orgs %>%
    rename_with(
      ~ level,
      starts_with('name')
    )

  if (lev == 2) {
    orgs <- orgs %>%
      mutate(county = str_remove(county, ' County'))
  } else if (lev == 3) {
    orgs <- orgs %>%
      mutate(
        county = str_remove(county, ' County'),
        subcounty = str_remove(subcounty, ' Subcounty')
      )
  } else if (lev == 4) {
    orgs <- orgs %>%
      mutate(
        county = str_remove(county, ' County'),
        subcounty = str_remove(subcounty, ' Subcounty'),
        ward = str_remove(ward, ' Ward')
      )
  }

  return(orgs)
}
