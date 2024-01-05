#' Get Category Options Metadata
#'
#' `get_category_options_metadata()` fetches category options from the KHIS API
#'
#' @param ... Options that can be passed onto KHIS API.
#'
#' @return A tibble containing the following columns:
#'
#' * category_id  - The unique identifier for the category option.
#' * category     - The name of the category option.
#'
#' @export
#'
#' @examplesIf khis_has_cred()
#' # Fetch the category option metadata
#' categories <- get_category_options_metadata()
#' categories

get_category_options_metadata <- function(...) {
x = categoryOptionCombos = name = category_id = category = NULL # due to NSE notes in R CMD check

  cat_group <- .api_get('categoryOptions',
                        fields='id,name,categoryOptionCombos',
                        ...)

  if (is_empty(cat_group$categoryOptions)) {
    cancerscreening_bullets(
      c(
        "!" = "Empty category options returned",
        "!" = "The KHIS server did not return any category options."
      )
    )

    return(tibble(
      category_id = character(),
      category = character()
    ))
  }

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
