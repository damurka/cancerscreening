#' Retrieve and Format Cervical Cancer Screening and Treatment Data
#'
#' `.get_cervical_data()` retrieves cervical cancer screening and treatment data
#'   for a specified period from the KHIS API server using the [get_analytics()].
#'
#' @inheritParams get_analytics
#'
#' @return A tibble containing cervical screening and treatment data with the
#'   following columns:
#'
#' * kenya      - Optional if the level is Kenya.
#' * county     - Name of the county. Optional if the level is `county`, `subcounty`, `ward` or `facility`.
#' * subcounty  - Name of the subcounty. Optional if the level is `subcounty`, `ward` or `facility`.
#' * ward       - Name of the ward. Optional if the level is `ward` or `facility`.
#' * facility   - Name of the health facility. Optional if the level `facility`.
#' * period     - The month and year of the data.
#' * fiscal_year- The financial year of the report(July-June Cycle).
#' * year       - The calendar year of the report.
#' * month      - The month name of the report.
#' * category   - The age group category of the report (<25, 25-49, 50+).
#' * category2  - Additional category if available.
#' * element    - The data element (HPV, VIA or Pap Smear).
#' * source     - The source report (MOH 711 or MOH 745).
#' * value      - The number reported.
#'
#' @keywords internal
#'
#' @seealso
#'   [get_analytics()] for retrieving cervical cancer screening data
#'
#' @examplesIf khis_has_cred()
#' \dontrun{
#'   ## Cervical Cancer Screening
#'   # VR7vdS7P0Gb = Number of clients who received HPV Test
#'   # gQro1y7Rsbq = Number of clients who received Pap smear
#'   # rFtB3keaVWm = Number of clients who received VIA or VIA/ VILI Screening
#'   cacx_screening_ids <- c('VR7vdS7P0Gb', 'gQro1y7Rsbq', 'rFtB3keaVWm')
#'
#'   # Download data from February 2023 to current date
#'   data <- .get_cervical_data(element_ids = cacx_screening_ids, start_data = '2023-02-01')
#' }

.get_cervical_data <- function(element_ids,
                              start_date,
                              end_date = NULL,
                              level =c('kenya', 'county', 'subcounty', 'ward', 'facility'),
                              organisations = NULL,
                              categories = NULL,
                              elements = NULL,
                              ...) {

  data <- get_analytics(element_ids,
                        start_date = start_date,
                        end_date = end_date,
                        level = level,
                        organisations = organisations,
                        categories = categories,
                        elements = elements,
                        ...) %>%
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
