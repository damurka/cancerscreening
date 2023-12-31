#' Retrieves Data for Clinical Breast Examinations (CBE) Conducted
#'
#' `get_breast_cbe()` retrieves data for CBE conducted within a specified
#' period from the KHIS API server using [.get_breast_data()].
#'
#' @inheritParams .get_breast_data
#'
#' @return A tibble containing data for CBE conducted with the following columns:
#'
#' @export
#'
#' @seealso
#'   [.get_breast_data()] for retrieving and formatting breast data
#'
#' @examplesIf khis_has_cred()
#' # Download data from February 2023 to current date
#' data <- get_breast_cbe(start_date = '2023-02-01')
#' data

get_breast_cbe <- function(start_date,
                           end_date = NULL,
                           level =c('kenya', 'county', 'subcounty', 'ward', 'facility'),
                           organisations = NULL,
                           categories = NULL,
                           elements = NULL,
                           ...) {

  category2 = NULL # due to NSE notes in R CMD check

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
                           ...) %>%
    mutate(
      element = case_when(
        str_detect(element, 'Normal') ~ 'Normal',
        .default = 'Abnormal',
        .ptype = factor(levels = c('Normal', 'Abnormal'))
      )
    ) %>%
    select(-category2)

  return(data)
}
