#' Retrieves cervical cancer precancerous treatment data
#'
#' \code{get_cervical_treated()} retrieves cervical cancer precancerous treatment
#'   data for a specified period from the KHIS API server.
#'
#' @inheritParams .get_cervical_data
#'
#' @return A tibble containing cervical cancer precancerous treatment data with the following columns:
#' @inheritParams .get_cervical_data
#'
#' @seealso
#' get_analytics(), get_categories(), get_data_elements(), login_to_khis()
#'
#' @export

get_cervical_treated <- function(start_date,
                                 end_date = NULL,
                                 level =c('kenya', 'county', 'subcounty', 'ward', 'facility'),
                                 organisations = NULL,
                                 categories = NULL,
                                 elements = NULL,
                                 khis_session = dynGet("khis_default_session", inherits = TRUE),
                                 retry = 1,
                                 verbosity = 0) {

  # Yv6LiN65lCJ = Number of clients treated using Cryotherapy
  # uXi8AjF8YR0 = Number of clients treated using LEEP
  # MIQ3HgFlHnS = Number of clients treated using Thermocoagulation
  # lx4fx2bluTm = Number of other treatment given (e.g. Hysterectomy, cone biopsy)
  # UAbmyzuI2UE = MOH 711 Cervical cancer clients treated using Cryotherapy
  # TSlyElHZw9d = MOH 711 Cervical cancer treated using LEEP
  cacx_treatment_ids <- c(
    'Yv6LiN65lCJ', 'uXi8AjF8YR0', 'MIQ3HgFlHnS', 'lx4fx2bluTm',
    'UAbmyzuI2UE', 'TSlyElHZw9d'
  )

  data <- .get_cervical_data(cacx_treatment_ids,
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
        str_detect(element, 'LEEP') ~ 'LEEP',
        str_detect(element, 'Cryotherapy') ~ 'Cryotherapy',
        str_detect(element, 'Thermocoagulation') ~ 'Thermoablation',
        .default = 'Other',
        .ptype = factor(levels = c('Cryotherapy', 'Thermoablation', 'LEEP', 'Other'))
      )
    )

  return(data)
}
