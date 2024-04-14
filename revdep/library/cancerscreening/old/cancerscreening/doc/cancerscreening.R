## ----setup, include = FALSE---------------------------------------------------
auth_success <- tryCatch(
  cancerscreening:::khis_cred_docs(),
  cancerscreening_cred_internal_error = function(e) e
)

knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  error = TRUE,
  purl = cancerscreening::khis_has_cred(),
  eval = cancerscreening::khis_has_cred()
)

