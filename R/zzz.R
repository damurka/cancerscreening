.onLoad <- function(libname, pkgname) {

  if (identical(Sys.getenv("IN_PKGDOWN"), "true")) {
    tryCatch(
      khisr:::khis_cred_docs(),
      khis_cred_internal_error = function(e) NULL
    )
  }

  invisible()
}
