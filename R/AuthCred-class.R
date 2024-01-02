#' Create an AuthCred
#'
#' Constructor function for objects of class [AuthCred].
#'
#' @param username The KHIS username to be used in API calls
#' @param password The KHIS password to be used in API calls. Typically
#'   populated indirectly if stored using the [keyring]
#'
#' @return An object of class [AuthCred]
#' @keywords internal
#'
#' @examples
#' \dontrun{
#'   init_AuthCred(username = 'khis_username')
#' }

init_AuthCred <- function(username = NA_character_,
                          password = NULL) {
  AuthCred$new(
    username = username,
    password = password
  )
}

#' Authorization Credential
#'
#' An `AuthCred` object manages the authorization credentials that make request
#' to the KHIS API server.
#'
#' @details An `AuthCred` should be created through the constructor function
#' [init_AuthCred()], which has more details on the arguments
#'
#' @param config_path Path to a JSON configuration file.
#' @param username The KHIS username.
#' @param password The KHIS password.
#'
#' @keywords internal
#' @name AuthCred-class
AuthCred <- R6::R6Class('AuthCred', list(
  #' @field  config_path Path to a JSON configuration file.
  config_path = NULL,
  #' @field  username The KHIS username.
  username = NULL,
  #' @field password The KHIS password.
  password = NULL,
  #' @description Create a new AuthCred
  #' @details For more details on the parameters, see [init_AuthCred()]
  initialize = function(username = NA_character_,
                        password = NULL) {
    stopifnot(
      is_scalar_character(username),
      is.null(password)
    )

    self$username <- username
    self$password <- password
  },
  #' @description Set the KHIS username
  #' @param value The KHIS username
  set_username = function(value) {
    stopifnot(is.null(value) || is_string(value))
    self$username <- value
    invisible(self)
  },
  #' @description Get username
  get_username = function() {
    self$username
  },
  #' @description Set the KHIS password
  #' @param value The KHIS password
  set_password = function(value) {
    self$password <- value
    invisible(self)
  },
  #' @description Clear password
  clear_password = function() {
    self$set_password(NULL)
  },
  #' @description Get password
  get_password = function() {
    self$password
  },
  #' @description Report if we have credentials
  has_cred = function() {
    !is.null(self$password) & !is.null(self$username)
  }
))
