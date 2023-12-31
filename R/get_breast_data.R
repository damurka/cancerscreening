#' Retrieve and Format Breast Cancer Screening Data
#'
#' `.get_breast_data()` retrieves breast cancer screening data for a specified period
#' from the KHIS API server using [get_analytics()].
#'
#' @inheritParams get_analytics
#'
#' @return A tibble containing breast cancer screening data with the following columns:
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
#' * category   - The age group category of the report (25-34, 35-39, 40-55, 56-74, or 75+).
#' * category2  - Additional category if available.
#' * element    - The data element.
#' * value      - The number reported.
#'
#' @keywords internal
#'
#' @seealso
#'   [get_analytics()] for retrieving breast cancer screening data
#'
#' @examplesIf khis_has_cred()
#' # Clinical Breast Examination data elements
#' # XEX93uLsAm2 = CBE Abnormal
#' # cXe64Yk0QMY = CBE Normal
#' element_id = c('cXe64Yk0QMY', 'XEX93uLsAm2')
#'
#' # Download data from February 2023 to current date
#' data <- .get_breast_data(element_ids = element_id, start_date = '2023-02-01')
#' data

.get_breast_data <- function(element_ids,
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
        str_detect(category, '25-34') ~ '25-34',
        str_detect(category, '35-39') ~ '35-39',
        str_detect(category, '40-55') ~ '40-55',
        str_detect(category, '56-74') ~ '56-74',
        .default = '75+',
        .ptype = factor(levels = c('25-34', '35-39', '40-55', '56-74', '75+'))
      )
    )
  return(data)
}
