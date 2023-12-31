#' Retrieves Data for Mammograms Conducted
#'
#' `get_breast_mammogram()` retrieves data for mammograms conducted within a
#' specified period from the KHIS API server using [.get_breast_data()].
#'
#' @inheritParams .get_breast_data
#'
#' @return A tibble containing data for mammograms conducted with the following columns:
#'
#' @export
#'
#' @seealso
#'   [.get_breast_data()] for retrieving and formatting breast data
#'
#' @examplesIf khis_has_cred()
#'
#' # Download data from February 2023 to current date
#' data <- get_breast_mammogram(start_date = '2023-02-01')
#' data

get_breast_mammogram <- function(start_date,
                                 end_date = NULL,
                                 level =c('kenya', 'county', 'subcounty', 'ward', 'facility'),
                                 organisations = NULL,
                                 categories = NULL,
                                 elements = NULL,
                                 ...) {

  # Mammogram screening element ids
  # T3crNg5D3Xa = Mammogram - BIRADS-0 to 3
  # Sorvgq7NDug = Mammogram - BIRADS-4
  # bi1ipJR6zNJ = Mammogram - BIRADS-5
  # APhWHU4KLWF = Mammogram - BIRADS-6
  mammogram_element_ids <- c('T3crNg5D3Xa', 'Sorvgq7NDug', 'bi1ipJR6zNJ', 'APhWHU4KLWF')

  data <- .get_breast_data(mammogram_element_ids,
                           start_date,
                           end_date = end_date,
                           level = level,
                           organisations = organisations,
                           categories = categories,
                           elements = elements,
                           ...) %>%
    mutate(
      element = case_when(
        str_detect(element, 'BIRADS-0 to 3') ~ 'BIRADS 0-3',
        str_detect(element, 'BIRADS-4') ~ 'BIRADS 4',
        str_detect(element, 'BIRADS-5') ~ 'BIRADS 5',
        .default = 'BIRADS 6',
        .ptype = factor(levels = c('BIRADS 0-3', 'BIRADS 4', 'BIRADS 5', 'BIRADS 6'))
      ),
      category2 = case_when(
        str_detect(element, 'BIRADS 0-3') ~ 'Normal',
        .default = 'Abnormal',
        .ptype = factor(levels = c('Normal', 'Abnormal'))
      )
    )

  return(data)
}
