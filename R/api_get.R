#' Make an API Call to the Kenya Health Information System (KHIS) Server
#'
#' `.api_get()` function executes a GET request to the KHIS API server, handling
#' authentication, query parameters, retries, and logging.
#'
#' @param url_path The API endpoint path to call (e.g., "analytics", "dataElements").
#' @param ... Additional query parameters for the API call.
#' @param retry Number of times to retry the API call in case of failure
#'   (defaults to 1).
#' @param verbosity Level of information to print during the call:
#'  - 0: No output
#'  - 1: Show headers
#'  - 2: Show headers and bodies
#'  - 3: Show headers, bodies, and curl status message
#'
#' @return A parsed JSON object containing the API response data.
#'
#' @details Retrieves credentials from the [keyring] using the current user's
#'   username. Uses HTTP Basic Authentication with credentials (consider using
#'   environment variables or a configuration file for security).
#'
#' @examplesIf khis_has_cred()
#' # Retrieve analytics data for a specific period:
#' analytics_data <- .api_get("analytics", startDate = "2023-01-01", endDate = "2023-02-28")
#' analytics_data
#'
#' @keywords internal

.api_get <- function(url_path,
                     ...,
                     retry = 1,
                     verbosity = 0) {

  params <- list(
    ...,
    paging = FALSE,
    ignoreLimit = TRUE
  )

  resp <- request('https://hiskenya.org/api') %>%
    req_url_path_append(url_path) %>%
    req_url_query(!!!params) %>%
    req_retry(max_tries = retry) %>%
    req_user_agent('Cancer Screening R') %>%
    req_auth_khis_basic() %>%
    req_perform(verbosity = verbosity) %>%
    resp_body_json()

  return(resp)
}
