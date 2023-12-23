#' Retrieves data for clinical breast examinations (CBE) conducted
#'
#' \code{get_breast_cbe()} retrieves data for CBE conducted within a specified
#' period from the KHIS API server.
#'
#' @inheritParams .get_breast_data
#'
#' @return A tibble containing data for CBE conducted with the following columns:
#' @inheritParams .get_breast_data
#'
#' @export

get_breast_cbe <- function(start_date,
                           end_date = NULL,
                           level =c('kenya', 'county', 'subcounty', 'ward', 'facility'),
                           organisations = NULL,
                           categories = NULL,
                           elements = NULL,
                           khis_session = dynGet("khis_default_session", inherits = TRUE),
                           retry = 1,
                           verbosity = 0) {

  # Clinical Breast Examination data elements
  # XEX93uLsAm2 = CBE Abnormal
  # cXe64Yk0QMY = CBE Normal
  cbe_element_ids <- c('cXe64Yk0QMY', 'XEX93uLsAm2')

  data <- .get_breast_data(cbe_element_ids,
                           start_date,
                           end_date = end_date,
                           level = level,
                           organisations = organisations,
                           categories = categories,
                           elements = elements,
                           khis_session = khis_session,
                           retry = retry,
                           verbosity = verbosity)

  return(data)
}
