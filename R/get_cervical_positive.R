#' Retrieves cervical cancer screening data with positive results
#'
#' \code{get_cervical_positive()} retrieves cervical cancer screening data with positive results
#'   for a specified period from the KHIS API server.
#'
#' @inheritParams .get_cervical_data
#'
#' @return A tibble containing cervical cancer screening data with positive results
#'   with the following columns:
#' @inheritParams .get_cervical_data
#'
#' @seealso
#' get_analytics(), get_categories(), get_data_elements(), login_to_khis()
#'
#' @export

get_cervical_positive <- function(start_date,
                                  end_date = NULL,
                                  level =c('kenya', 'county', 'subcounty', 'ward', 'facility'),
                                  organisations = NULL,
                                  categories = NULL,
                                  elements = NULL,
                                  khis_session = dynGet("khis_default_session", inherits = TRUE),
                                  retry = 1,
                                  verbosity = 0) {

  # wYHt86csbhn = Number of clients with Positive Cytology result
  # KLQZDP0ycOY = Number of clients with Positive HPV result
  # xBjAMa2KFwD = Number of clients with Positive VIA or VIA/VILI result
  # La4v1gAs5cp = Number of clients with suspicious cancer lesions
  # xbERCTpWTwi = MOH 711 Cervical cancer clients with Positive Cytology result
  # LI2g0vO0xvx = MOH 711 Cervical cancer clients with Positive HPV result
  # dBdw7Inlq2C = MOH 711 Cervical cancer clients with Positive VIA/VILI result
  # FC5BbFDsdCa = MOH 711 Clients with suspicious cancer lesion
  cacx_positive_ids <- c(
    'wYHt86csbhn', 'KLQZDP0ycOY', 'xBjAMa2KFwD', 'La4v1gAs5cp',
    'xbERCTpWTwi', 'LI2g0vO0xvx', 'dBdw7Inlq2C', 'FC5BbFDsdCa'
  )

  data <- .get_cervical_data(cacx_positive_ids,
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
        str_detect(element, 'Cytology') ~'Pap Smear',
        .default = 'Suspicious Lesion',
        .ptype = factor(levels = c('VIA', 'HPV', 'Pap Smear', 'Suspicious Lesion'))
      )
    )

  return(data)
}
