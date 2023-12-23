#' Retrieves cervical cancer screening data on HIV positive women
#'
#' \code{get_cervical_hiv_screened()} retrieves cervical cancer screening and treatment
#'   data for a specified period from the KHIS API server.
#'
#' @inheritParams .get_cervical_data
#'
#' @return A tibble containing cervical cancer screening data on HIV positive women
#'   with the following columns:
#' @inheritParams .get_cervical_data
#'
#' @seealso
#' get_analytics(), get_categories(), get_data_elements(), login_to_khis()
#'
#' @export

get_cervical_hiv_screened <- function(start_date,
                                      end_date = NULL,
                                      level =c('kenya', 'county', 'subcounty', 'ward', 'facility'),
                                      organisations = NULL,
                                      categories = NULL,
                                      elements = NULL,
                                      khis_session = dynGet("khis_default_session", inherits = TRUE),
                                      retry = 1,
                                      verbosity = 0) {

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
                             khis_session = khis_session,
                             retry = retry,
                             verbosity = verbosity) %>%
    mutate(
      element = factor(ifelse(str_detect(element, 'screened'), 'Screened', 'Positive'))
    )

  return(data)
}
