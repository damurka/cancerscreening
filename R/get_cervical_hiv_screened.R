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
#' @export
#'
#' @seealso
#'   [.get_cervical_data()] for retrieving and formatting cervical cancer screening data
#'
#' @examplesIf khis_has_cred()
#' # Download data from February 2023 to current date
#' data <- get_cervical_hiv_screened(start_date = '2023-02-01')
#' data

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
