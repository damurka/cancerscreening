#' Get a list of data elements
#'
#' \code{get_data_elements()} retrieves a list of data elements from the KHIS API
#'   server, including their IDs and names.
#'
#' @param element_ids A vector of specific data element IDs to retrieve. If NULL, all data elements will be retrieved.
#' @param khis_session The KHIS session object to use (defaults to "khis_default_session"). See `?login_to_khis()` for details.
#' @param retry Number of times to retry the API call in case of failure (defaults to 1).
#' @param verbosity Level of information to print during the API call:
#'  - 0: No output
#'  - 1: Show headers
#'  - 2: Show headers and bodies
#'  - 3: Show headers, bodies, and curl status message
#'
#' @return A tibble containing the following columns:
#' \describe{
#'  \item{element_id}{The unique identifier for the data element.}
#'  \item{element}{The name of the data element.}
#' }
#'
#' @seealso
#' [login_to_khis()]
#'
#' @export


get_data_elements <-function(element_ids = NULL,
                             khis_session = dynGet("khis_default_session", inherits = TRUE),
                             retry = 1,
                             verbosity = 0) {

  x = name = filter = NULL # due to NSE notes in R CMD check

  if (!is.null(element_ids) && length(element_ids) > 0) {
    filter <- str_c(element_ids, collapse = ',')
    filter <- str_c('id:in:[', filter, ']')
  }

  data <- .api_get('dataElements',
                   fields='id,name',
                   filter=filter,
                   khis_session = khis_session,
                   retry = retry,
                   verbosity = verbosity)

  data <- tibble(x = data$dataElements) %>%
    unnest_wider(x) %>%
    rename(
      element_id = id,
      element = name
    )

  return(data)
}
