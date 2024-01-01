#' Retrieves Cervical Cancer Screening Data on HIV Positive Women
#'
#' `get_cervical_hiv_screened()` retrieves cervical cancer screening and treatment
#'   data for a specified period from the KHIS API server using [.get_cervical_data()].
#'
#' @inheritParams .get_cervical_data
#'
#' @return A tibble containing cervical cancer screening data on HIV positive women
#'   with the following columns:
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
#' @export
#'
#' @seealso
#'   [.get_cervical_data()] for retrieving and formatting cervical cancer screening data
#'
#' @examplesIf khis_has_cred()
#' # Download data from February 2023 to current date
#' screened <- get_cervical_hiv_screened(start_date = '2023-02-01')
#' screened

get_cervical_hiv_screened <- function(start_date,
                                      end_date = NULL,
                                      level =c('kenya', 'county', 'subcounty', 'ward', 'facility'),
                                      organisations = NULL,
                                      categories = NULL,
                                      elements = NULL,
                                      ...) {

  element = NULL # due to NSE notes in R CMD check

  ## Cervical Cancer Screening to HIV positive women
  # htFuvGJRW1X = Number of HIV positive clients screened
  # joXHDIBe8I2 = Number of HIV positive with positive screening results
  # n8Z1XFaeS1t = MOH 711 HIV positive clients screened for cervical cancer
  cacx_hiv_screening_ids <- c('htFuvGJRW1X', 'joXHDIBe8I2', 'n8Z1XFaeS1t')

  data <- .get_cervical_data(cacx_hiv_screening_ids,
                             start_date,
                             end_date = end_date,
                             level = level,
                             organisations = organisations,
                             categories = categories,
                             elements = elements,
                             ...) %>%
    mutate(
      element = factor(ifelse(str_detect(element, 'screened'), 'Screened', 'Positive'))
    )

  return(data)
}
