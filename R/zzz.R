.onLoad <- function(libname, pkgname) {

  # .auth is created in R/khis_cred.R
  # this is to insure we get an instance of AuthCred
  utils::assignInMyNamespace(
    '.auth',
    init_AuthCred()
  )

  if (identical(Sys.getenv("IN_PKGDOWN"), "true")) {
    tryCatch(
      khis_cred_docs(),
      cancerscreening_cred_internal_error = function(e) NULL
    )
  }

  kb <- keyring::default_backend('cancerscreening')
  tryCatch(
    kb$keyring_create('cancerscreening', 'cancerscreening'),
    error = function(e) NULL
  )

  invisible()
}
