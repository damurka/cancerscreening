auth_sucess <- tryCatch(
  khis_cred_testing(),
  cancerscreening_internal_error = function(e) NULL
)
if(!isTRUE(auth_sucess)) {
  khis_cred_clear()
}

skip_if_no_cred <- function() {
  testthat::skip_if_not(khis_has_cred(), "No KHIS credentials")
}
