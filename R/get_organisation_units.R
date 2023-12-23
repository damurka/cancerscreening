
#' Get a list of organisation units in KHIS
#'
#' [get_organisation_units()] retrieves a list of organisation units from the
#'   KHIS API server, including their names, counties, subcounties, and wards.
#'
#' @param khis_session The KHIS session object to use (defaults to "khis_default_session").
#'   See `?login_to_khis()` for details.
#' @param retry Number of times to retry the API call in case of failure (defaults to 1).
#' @param verbosity Level of information to print during the API call:
#'  - 0: No output
#'  - 1: Show headers
#'  - 2: Show headers and bodies
#'  - 3: Show headers, bodies, and curl status message
#'
#' @return A tibble containing the following columns:
#' \describe{
#'  \item{facility_id}{Organisation identifier that uniquely identifies the health facility.}
#'  \item{ward_id}{Organisation identifier that uniquely identifies the ward.}
#'  \item{subcounty_id}{Organisation identifier that uniquely identifies the subcounty.}
#'  \item{county_id}{Organisation identifier that uniquely identifies the county.}
#'  \item{facility}{Name of the health facility.}
#'  \item{county}{Name of the county.}
#'  \item{subcounty}{Name of the subcounty.}
#'  \item{ward}{Name of the ward.}
#' }
#'
#' @seealso
#' [login_to_khis()]
#'
#' @export

get_organisation_units <- function(khis_session = dynGet("khis_default_session", inherits = TRUE),
                                   retry = 1,
                                   verbosity = 0) {
  orgs <- .api_get('organisationUnits',
                   khis_session = khis_session,
                   fields='id,name,path',
                   retry = retry,
                   verbosity = verbosity)

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
