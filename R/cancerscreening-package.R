#' @description
#' cancerscreening provide a easy way to download cancer screening data from the
#'   Kenya Health Information System (KHIS) using R.
#'
#' Most function begin with the prefix `get_` followed by the screening area
#' `cervical` or `breast`. The Goal is to allow the download of data associated
#' with the data of interest, e.g. `get_cervical_screened`, `get_cervical_positive`,
#' or `get_cervical_treated`.
#'
#' cancerscreening is "pipe-friendly" and, infact rexports `%>%` but does not
#' require its use.
#'
#' Please see the cancerscreening website for full documentation:
#'   * <https://cancerscreening.damurka.com/index.html>
#'
#' In addition to function-specific help, there are several articles which are
#' indexed here:
#' * [Article index](https://cancerscreening.damurka.com/articles/index.html)
#'
#' @keywords internal
#' @import dplyr
#' @import tidyr
#' @import rlang
"_PACKAGE"

## usethis namespace: start
#' @importFrom gargle secret_decrypt_json
#' @importFrom gargle secret_has_key
#' @importFrom httr2 req_auth_basic
#' @importFrom httr2 req_perform
#' @importFrom httr2 req_retry
#' @importFrom httr2 req_url_path_append
#' @importFrom httr2 req_url_query
#' @importFrom httr2 req_user_agent
#' @importFrom httr2 request
#' @importFrom httr2 resp_body_json
#' @importFrom lubridate month
#' @importFrom lubridate quarter
#' @importFrom lubridate today
#' @importFrom lubridate year
#' @importFrom lubridate ym
#' @importFrom lubridate ymd
#' @importFrom stringr str_c
#' @importFrom stringr str_detect
#' @importFrom stringr str_glue
#' @importFrom stringr str_remove
#' @importFrom stringr str_trim
#' @importFrom tibble tibble
## usethis namespace: end
NULL
