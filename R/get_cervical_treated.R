#' Retrieves Cervical Cancer Precancerous Treatment Data
#'
#' `get_cervical_treated()` retrieves cervical cancer precancerous treatment
#'   data for a specified period from the KHIS API server using [.get_cervical_data()].
#'
#' @inheritParams .get_cervical_data
#'
#' @return A tibble containing cervical cancer precancerous treatment data with the following columns:
#'
#' @export
#'
#' @seealso
#'   [.get_cervical_data()] for retrieving and formatting cervical cancer screening data
#'
#' @examplesIf khis_has_cred()
#' # Download data from February 2023 to current date
#' data <- get_cervical_treated(start_date = '2023-02-01')
#' data

get_cervical_treated <- function(start_date,
                                 end_date = NULL,
                                 level =c('kenya', 'county', 'subcounty', 'ward', 'facility'),
                                 organisations = NULL,
                                 categories = NULL,
                                 elements = NULL,
                                 ...) {

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
                             ...) %>%
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
