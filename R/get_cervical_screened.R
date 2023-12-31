#' Retrieves Cervical Cancer Screening Data
#'
#' `get_cervical_screened()` retrieves cervical cancer screening data for a
#'    specified period from the KHIS API server using [.get_cervical_data()].
#'
#' @inheritParams .get_cervical_data
#'
#' @return A tibble containing cervical cancer screening data with the following columns:
#'
#' @export
#'
#' @seealso
#'   [.get_cervical_data()] for retrieving and formatting cervical cancer screening data
#'
#' @examplesIf khis_has_cred()
#' # Download data from February 2023 to current date
#' data <- get_cervical_screened(start_date = '2023-02-01')
#' data

get_cervical_screened <- function(start_date,
                                  end_date = NULL,
                                  level =c('kenya', 'county', 'subcounty', 'ward', 'facility'),
                                  organisations = NULL,
                                  categories = NULL,
                                  elements = NULL,
                                  ...) {

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
                             ...) %>%
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
