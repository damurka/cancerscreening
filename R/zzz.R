.onLoad <- function(libname, pkgname) {

  # .auth is created in R/khis_cred.R
  # this is to insure we get an instanxe of AuthCred
  utils::assignInMyNamespace(
    '.auth',
    init_AuthCred()
  )

  invisible()
}
