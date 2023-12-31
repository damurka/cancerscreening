#' Get Category Options Metadata
#'
#' `get_category_options_metadata()` fetches category options from the KHIS API
#'
#' @param ... Options that can be passed onto [.api_get].
#'
#' @return A tibble containing the following columns:
#'
#' * category_id  - The unique identifier for the category option.
#' * category     - The name of the category option.
#'
#' @export
#'
#' @seealso
#'   [.api_get()] for making API call to KHIS server
#'
#' @examplesIf khis_has_cred()
#' # Fetch the category option metadata
#' data <- get_category_options_metadata()

get_category_options_metadata <- function(...) {
x = categoryOptionCombos = name = category_id = category = NULL # due to NSE notes in R CMD check

  cat_group <- .api_get('categoryOptions',
                        fields='id,name,categoryOptionCombos',
                        ...)

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
