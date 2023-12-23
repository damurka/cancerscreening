#' Retrieves cervical cancer screening and treatment data
#'
#' \code{.get_cervical_data()} retrieves cervical cancer screening and treatment data for a specified period from the KHIS API server.
#'
#' @param element_ids A vector of data element IDs to retrieve data for.
#' @param start_date The start date for the data retrieval in the format 'YYYY-MM-dd'.
#' @param end_date The end date for the data retrieval in the format 'YYYY-MM-dd'. Defaults to the current date if not specified.
#' @param level The desired level of the organization unit hierarchy to retrieve data for: "kenya", "county", "subcounty", "ward", or "facility".
#' @param organisations A vector of specific organisation unit IDs to retrieve data for. If NULL, data for all organisation units at the specified level will be retrieved.
#' @param categories A tibble of category options, typically obtained from \code{get_categories()}. If NULL, categories will be downloaded automatically.
#' @param elements A tibble of data elements, typically obtained from \code{get_data_elements()}. If NULL, elements will be downloaded automatically.
#' @param khis_session The KHIS session object to use (defaults to "khis_default_session"). See `?login_to_khis()` for details.
#' @param retry Number of times to retry the API call in case of failure (defaults to 1).
#' @param verbosity Level of information to print during the API call:
#'  - 0: No output
#'  - 1: Show headers
#'  - 2: Show headers and bodies
#'  - 3: Show headers, bodies, and curl status message
#'
#' @return A tibble containing cervical screening and treatment data with the following columns:
#' \describe{
#'  \item{facility}{Name of the health facility.}
#'  \item{ward}{Name of the ward.}
#'  \item{subcounty}{Name of the subcounty.}
#'  \item{county}{Name of the county.}
#'  \item{period}{Date of the report.}
#'  \item{month}{Month of the report.}
#'  \item{year}{Year of the report.}
#'  \item{fiscal_year}{Financial year of the report (July-June cycle).}
#'  \item{category}{Age group category (<25, 25-49, 50+).}
#'  \item{category2}{Additional category option (if applicable).}
#'  \item{element}{Name of the data element.}
#'  \item{source}{Source document of the report (MOH 711 or MOH 745).}
#'  \item{value}{Numeric value for the number of cases reported.}
#' }
#'
#' @seealso
#' get_analytics(), get_categories(), get_data_elements(), login_to_khis()
#'
#' @keywords internal

.get_cervical_data <- function(element_ids,
                              start_date,
                              end_date = NULL,
                              level =c('kenya', 'county', 'subcounty', 'ward', 'facility'),
                              organisations = NULL,
                              categories = NULL,
                              elements = NULL,
                              khis_session = dynGet("khis_default_session", inherits = TRUE),
                              retry = 1,
                              verbosity = 0) {

  data <- get_analytics(element_ids,
                        start_date = start_date,
                        end_date = end_date,
                        level = level,
                        organisations = organisations,
                        categories = categories,
                        khis_session = khis_session,
                        retry = retry,
                        verbosity = verbosity) %>%
    mutate(
      category = case_when(
        str_detect(category, '<25') ~ '<25',
        str_detect(category, '25-49') ~ '25-49',
        .default = '50+',
        .ptype = factor(levels = c('<25', '25-49', '50+'))
      ),
      source = case_when(
        str_detect(element, 'MOH 711') ~ 'MOH 711',
        .default = 'MOH 745',
        .ptype = factor(levels = c('MOH 711', 'MOH 745'))
      )
    )

  return(data)
}
