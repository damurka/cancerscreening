#' Get Category Options Metadata
#'
#' `get_category_options_metadata()` fetches category options from the KHIS API
#'
#' @inheritDotParams khisr::get_metadata -endpoint
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

  cat_group <- get_category_options(..., fields='id,name,categoryOptionCombos')

  if (is_empty(cat_group)) {
    return(NULL)
  }

  cat_group <- cat_group %>%
    unnest_longer(categoryOptionCombos) %>%
    unnest_longer(categoryOptionCombos) %>%
    rename(
      category_id = categoryOptionCombos,
      category = name
    ) %>%
    select(category_id, category)

  return(cat_group)
}
