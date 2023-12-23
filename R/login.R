
#' @import R6
#'
khisSession <- R6::R6Class("khisSession",
                           #' @title khisSession
                           public = list(
                             #' @field  config_path Path to a JSON configuration
                             #' file.
                             config_path = NULL,
                             #' @field  username The KHIS username.
                             username = NULL,

                             #' @description
                             #' Create a new KHISLogin object
                             #' @param config_path Configuration file path
                             #' @param username URL to the server.
                             initialize = function(config_path = NA_character_, username) {
                               self$config_path <- config_path
                               self$username <- username
                             }
                           )
)
#' Logins into a KHIS system
#'
#' \code{loginToKHIS} provides credentials for making an API call
#'
#' @param config_path path to a KHIS config file. If provided, username and
#'password should not be provided.
#' @param config_path_level if there a multiple json entries in the config
#' file, it will default to KHIS
#' @param username KHIS username. If provided config_path must be NULL
#' @param password KHIS password for the username. Optional If not provided you will be
#' prompted to input password
#' @param khis_session_name the variable name for the khisSession object.
#' The default name is d2_default_session and will be used by other \code{cancerscreening}
#' functions by default when connecting to KHIS Generally a custom name
#' should only be needed if you need to log into two separate KHIS instances
#' at the same time. If you create a khisSession object with a custom name then
#' this object must be passed to other \code{cancerscreening} functions explicitly
#' @param khis_session_envir the environment in which to place the R6 login
#' object, default is the immediate calling environment
#'
#' @export

login_to_khis <- function(config_path = NULL,
                        config_path_level = "khis",
                        username = NULL,
                        password = NULL,
                        khis_session_name = "khis_default_session",
                        khis_session_envir = parent.frame()) {
  if (is.null(config_path) && is.null(username)) {
    stop("Pass credential through config path or username")
  }

  if (!(is.null(config_path)) && !(is.null(username))) {
    stop("If using config_path then credentials can not be passed in directly")
  }

  if (!is.null(config_path)) {
    # loads credentials from secret file
    credentials <- .load_config_file(config_path = config_path)
    credentials <- credentials[[config_path_level]]
    password <- credentials[["password"]]
    username <- credentials[["username"]]
  }

  if (is.null(password)) {
    password <- ""
  }

  # checks if password in file and if not checks keyring, and if not there
  # prompts to make one
  if (nchar(password) == 0) {
    password <- try(keyring::key_get(
      service = 'khis-service',
      username = username
    ))
    if ("try-error" %in% class(password)) {
      keyring::key_set(service = 'khis-service', username = username)
      password <- keyring::key_get(
        service = 'khis-service',
        username = credentials[["username"]]
      )
    }
  } else {
    keyring::key_set_with_value(
      service = 'khis-service',
      username = username,
      password = password
    )
  }

  assign(khis_session_name,
         khisSession$new(config_path = config_path,
                         username = username),
         envir = khis_session_envir)
}

#' @title LoadConfig(config_path)
#'
#' @description Loads a JSON configuration file to access a KHIS instance
#' @param config_path Path to the KHIS credentials file
#' @return A parsed list of the configuration file.
#'
#'@noRd

.load_config_file <- function(config_path = NA) {
  # Load from a file
  if (!is.na(config_path)) {
    if (file.access(config_path, mode = 4) == -1) {
      stop(paste("Cannot read configuration located at", config_path))
    }
    dhis_config <- jsonlite::fromJSON(config_path)
    return(dhis_config)
  } else {
    stop("You must specify a credentials file!")
  }
}

#' @title .get_credentials_from_keyring(ring, service, username)
#'
#' @description retrieves username, service, and password from keyring
#' @param username KHIS username
#' @return a list containing entries called password and username
#'
#' @noRd

.get_credentials_from_keyring <- function(username) {
  credentials <- c("password" = keyring::key_get('khis-service', username))
  return(credentials)
}
