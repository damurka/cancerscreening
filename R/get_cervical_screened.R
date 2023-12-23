#' Retrieves cervical cancer screening data
#'
#'  \code{get_cervical_screened()} retrieves cervical cancer screening data for a
#'    specified period from the KHIS API server.
#'
#' @inheritParams .get_cervical_data
#'
#' @return A tibble containing cervical cancer screening data with the following columns:
#' @inheritParams .get_cervical_data
#'
#' @seealso
#' get_analytics(), get_categories(), get_data_elements(), login_to_khis()
#'
#' @export

get_cervical_screened <- function(start_date,
                                  end_date = NULL,
                                  level =c('kenya', 'county', 'subcounty', 'ward', 'facility'),
                                  organisations = NULL,
                                  categories = NULL,
                                  elements = NULL,
                                  khis_session = dynGet("khis_default_session", inherits = TRUE),
                                  retry = 1,
                                  verbosity = 0) {

  ## Cervical Cancer Screening
  # VR7vdS7P0Gb = Number of clients who received HPV Test
  # gQro1y7Rsbq = Number of clients who received Pap smear
  # rFtB3keaVWm = Number of clients who received VIA or VIA/ VILI Screening
  # ommbnTANmGo = MOH 711 Clients screened for Cervical Cancer using HPV test
  # kl4RvWOGb7x = MOH 711 Clients screened  using Pap smear
  # G9COyloYLYa = MOH 711 Clients screened using VIA /VILI /HPV VILI / HPV
  cacx_screening_ids <- c(
    'VR7vdS7P0Gb', 'gQro1y7Rsbq', 'rFtB3keaVWm',
    'ommbnTANmGo', 'kl4RvWOGb7x', 'G9COyloYLYa'
  )

  data <- .get_cervical_data(cacx_screening_ids,
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
      element = case_when(
        str_detect(element, 'VIA') ~ 'VIA',
        str_detect(element, 'HPV') ~ 'HPV',
        str_detect(element, 'Pap') ~'Pap Smear',
        .ptype = factor(levels = c('VIA', 'HPV', 'Pap Smear'))
      )
    )

  return(data)
}
