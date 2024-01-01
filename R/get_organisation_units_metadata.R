
#' Get Organisation Units Metadata
#'
#' [get_organisation_units_metadata()] fetches organisation units metadata from the
#'   KHIS API server.
#'
#' @param ... Options that can be passed onto [.api_get].
#'
#' @return A tibble containing the following columns:
#'
#'  * facility_id   - Organisation identifier that uniquely identifies the health facility.
#'  * ward_id       - Organisation identifier that uniquely identifies the ward.
#'  * subcounty_id  - Organisation identifier that uniquely identifies the subcounty.
#'  * county_id     - Organisation identifier that uniquely identifies the county.
#'  * facility      - Name of the health facility.
#'  * county        - Name of the county.
#'  * subcounty     - Name of the subcounty.
#'  * ward          - Name of the ward.
#'
#' @export
#'
#' @seealso
#'   [.api_get()] for making API call to KHIS server
#'
#' @examplesIf khis_has_cred()
#' # Fetch all the organisation units metadata
#' organisations <- get_organisation_units_metadata()
#' organisations

get_organisation_units_metadata <- function(...) {
  x = path = facility_id = name = county = subcounty = ward = no_data = community_id = NULL # due to NSE notes in R CMD check

  orgs <- .api_get('organisationUnits',
                   fields='id,name,path',
                   ...)

  orgs <- tibble(x = orgs$organisationUnits) %>%
    unnest_wider(x)

  headers <- c('no_data', 'kenya_id', 'county_id', 'subcounty_id', 'ward_id', 'facility_id', 'community_id')

  orgs <- orgs %>%
    separate(path, headers, sep = '/', remove = TRUE, fill = 'right') %>%
    filter(!is.na(facility_id)) %>%
    distinct(facility_id, .keep_all = TRUE) %>%
    rename(facility = name) %>%
    left_join(orgs %>% select(id, name) %>% rename(ward = name), by=c('ward_id'='id')) %>%
    left_join(orgs %>% select(id, name) %>% rename(subcounty = name), by=c('subcounty_id'='id')) %>%
    left_join(orgs %>% select(id, name) %>% rename(county = name), by=c('county_id'='id')) %>%
    left_join(orgs %>% select(id, name) %>% rename(kenya = name), by=c('kenya_id'='id')) %>%
    mutate(
      county = str_remove(county, ' County'),
      subcounty = str_remove(subcounty, ' Sub County'),
      ward = str_remove(ward, ' Ward')
    ) %>%
    select(-id, -no_data, -community_id)

  return(orgs)
}
