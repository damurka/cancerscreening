#' Get a list of category options
#'
#' \code{get_categories()} retrieves a list of category options from the KHIS API
#'   server, including their IDs and names.
#'
#' @param khis_session The KHIS session object to use (defaults to "khis_default_session").
#'   See `?login_to_khis()` for details.
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
#'  \item{category_id}{The unique identifier for the category option.}
#'  \item{category}{The name of the category option.}
#' }
#'
#' @seealso
#' [login_to_khis()]
#'
#' @export

get_categories <- function(khis_session = dynGet("khis_default_session", inherits = TRUE),
                           retry = 1,
                           verbosity = 0) {

  cat_group <- .api_get('categoryOptions',
                        fields='id,name,categoryOptionCombos',
                        khis_session = khis_session,
                        retry = retry,
                        verbosity = verbosity)

  cat_group <- tibble(x = cat_group$categoryOptions) %>%
    unnest_wider(x) %>%
    unnest_longer(categoryOptionCombos) %>%
    unnest_longer(categoryOptionCombos) %>%
    rename(
      category_id = categoryOptionCombos,
      category = name
    ) %>%
    select(category_id, category)

  return(cat_group)
}
