#' Make an API call to the Kenya Health Information System (KHIS) server
#'
#' `.api_get()` function executes a GET request to the KHIS API server, handling
#' authentication, query parameters, retries, and logging.
#'
#' @param url_path The API endpoint path to call (e.g., "analytics", "dataElements").
#' @param khis_session The KHIS session object to use (defaults to "khis_default_session").
#'   See `?login_to_khis()` for details.
#' @param ... Additional query parameters for the API call (name-value pairs, automatically escaped).
#' @param retry Number of times to retry the API call in case of failure (defaults to 1).
#' @param verbosity Level of information to print during the call:
#'  - 0: No output
#'  - 1: Show headers
#'  - 2: Show headers and bodies
#'  - 3: Show headers, bodies, and curl status message
#'
#' @return A parsed JSON object containing the API response data.
#'
#' @details
#' Retrieves credentials from the keyring using the current user's username.
#' Sets a custom user agent string for the request.
#' Uses HTTP Basic Authentication with credentials (consider using environment
#'   variables or a configuration file for security).
#'
#' @examples
#'
#' # Retrieve analytics data for a specific period:
#' analytics_data <- api_get("analytics", startDate = "2023-01-01", endDate = "2023-02-28")
#'
#' @seealso
#' login_to_khis(), keyring package
#'
#' @noRd

.api_get <- function(url_path, khis_session, ..., retry = 1, verbosity = 0) {

  username <- khis_session$username
  if (is.null(username)) {
    stop("You are not logged into KHIS")
  }

  params <- list(
    ...,
    paging = FALSE,
    skipData = FALSE,
    skipMeta = TRUE,
    ignoreLimit = TRUE
  )

  credentials <- .get_credentials_from_keyring(username = username)

  resp <- request('https://hiskenya.org/api') %>%
    req_url_path_append(url_path) %>%
    req_url_query(!!!params) %>%
    req_retry(max_tries = retry) %>%
    req_user_agent('') %>%
    req_auth_basic(username, credentials['password']) %>%
    req_perform(verbosity = verbosity) %>%
    resp_body_json()

  return(resp)
}
