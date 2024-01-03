# This file is the interface between KHIS credential storage and cancerscreening package

# Initialization happens in .onLoad()
.auth <- NULL

#' Sets the KHIS Credentials
#'
#' @param config_path An optional parameters that contains the path to configuration file with username and password
#' @param username The KHIS username. Can be optional if `config_path` is already provided
#' @param password The KHIS password. Can be optional if `config_path` is already provided or already stored using the [keyring] package
#'
#' @family cred functions
#' @export
#'
#' @examplesIf rlang::is_interactive()
#' # Load username and password
#' khis_cred(username = 'damurka', password = 'PASSWORD')
#'
khis_cred <- function(config_path = NULL,
                      username = NULL,
                      password = NULL) {
  if (is.null(config_path) && is.null(username)) {
    cancerscreening_abort(
      message = c(
        "x" = "Missing credentials",
        "i" = "Please provide either {.field config_path} or {.field username}."
      ),
      class = "cancerscreening_missing_credentials"
    )
  }

  if (!(is.null(config_path)) && !(is.null(username))) {
    cancerscreening_abort(
      message = c(
        "x" = "{.field config_path} and {.field username} cannot be provided together.",
        "i" = "Remove one and try again!"
      ),
      class = "cancerscreening_multiple_credentials",
      config_path = config_path
    )
  }

  if (!is.null(config_path)) {
    # loads credentials from secret file
    credentials <- .load_config_file(config_path)
    password <- credentials[["password"]]
    username <- credentials[["username"]]

    if (is.null(password) || nchar(password) == 0 || is.null(username) || nchar(password) == 0) {
      cancerscreening_abort(
        message = c(
          "x" = "Missing credentials",
          "i" = "Please provide username and password to continue"
        ),
        class = "cancerscreening_missing_credentials"
      )
    }
  } else {
    password <- ifelse(is.null(password), "", password)

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
    } else if (is.null(config_path)) {
      keyring::key_set_with_value(
        service = 'khis-service',
        username = username,
        password = password
      )
    }
  }

  .auth$set_username(username)
  .auth$set_password(password)

  cancerscreening_bullets(c("i" = 'The credentials have been set.'))

  invisible()
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
  tryCatch({
    data <- jsonlite::fromJSON(config_path)
    if (!is.null(data) && 'credentials' %in% names(data)) {
      return(data[['credentials']])
    }
  }, error = function(e) {
    cancerscreening_abort(
      message = c(
        "x" = "Invalid {.field config_path} was provided.",
        "i" = "Check the {.field config_path} and try again!"
      ),
      class = "cancerscreening_invalid_config_path",
      config_path = config_path
    )
  })

  cancerscreening_abort(
    message = c(
      "x" = "Invalid {.field config_path} was provided.",
      "i" = "Please check the {.field config_path} format and try again"
    ),
    class = "cancerscreening_invalid_config_path",
    config_path = config_path
  )
}

#' Authenticate Request with HTTP Basic Authentication
#'
#' This sets the Authorization header for basic authentication using the username and password provided.
#'
#' @param req A request
#'
#' @return A modified HTTP request with authorization header
#'
#' @noRd
#'
#' @examples
#' req <- request("http://example.com") %>%
#'   req_auth_khis_basic("damurka", "PASSWORD")
#'
#' @seealso [httr2]

req_auth_khis_basic <- function(req) {
  if (!khis_has_cred()) {
    cancerscreening_abort(
      message = c(
        "x" = "Missing credentials",
        "i" = "Please set the credentials by calling {.fun khis_cred}"
      ),
      class = "cancerscreening_missing_credentials"
    )
  }
  httr2::req_auth_basic(req, .auth$username, .auth$password)
}

#' Are There Credentials on Hand?
#'
#' @family low-level API functions
#' @returns boolean value indicating if the credentials are available
#' @export
#'
#' @examples
#' khis_has_cred()

khis_has_cred <- function() {
  .auth$has_cred()
}

#' Clear the Credentials from Memory
#'
#' @family auth functions
#'
#' @export
#'
#' @examplesIf rlang::is_interactive()
#' khis_cred_clear()

khis_cred_clear <- function() {
  .auth$set_username(NULL)
  .auth$clear_password()
  invisible()
}

#' Produces the Configured Username
#'
#' @family low-level API functions
#'
#' @return the username of the user credentials
#' @export
#'
#' @examples rlang::is_interactive()
#' \dontrun{
#'   # Set the credentials
#'   khis_cred(username = 'user', password = 'password')
#'
#'   # View the username
#'   khis_username()
#'
#'   # Clear credentials
#'   khis_clear_cred()
#' }

khis_username <- function() {
  .auth$get_username()
}


#' Internal Credentials
#'
#' Internal function used to provide credentials for the testing and documentation
#'   environment
#'
#' @param account The environment to provide credentials. `"docs"` or `"testing"`
#'
#' @noRd

khis_cred_internal <- function(account = c('docs', 'testing')) {
  account <- match.arg(account)
  can_decrypt <- gargle::secret_has_key('CANCERSCREENING_KEY')
  online <- !is.null(curl::nslookup('hiskenya.org', error = FALSE))
  if (!can_decrypt || !online) {
    cancerscreening_abort(
      message = c(
        "Set cred unsuccessful:",
        if (!can_decrypt) {
          c("x" = "Can't decrypt the {.field {account}} credentials.")
        },
        if (!online) {
          c("x" = "We don't appear to be online. Or maybe the KHIS is down?")
        }
      ),
      class = "cancerscreening_cred_internal_error",
      can_decrypt = can_decrypt, online = online
    )
  }

  filename <- str_glue("cancerscreening-{account}.json")
  khis_cred(
    config_path = gargle::secret_decrypt_json(
      system.file('secret', filename, package = 'cancerscreening'),
      'CANCERSCREENING_KEY'
    )
  )
  print(khis_username())
  invisible(TRUE)
}

#' Set Credentials for Documentation
#'
#' @noRd

khis_cred_docs <- function() {
  khis_cred_internal('docs')
}

#' Set Credentials for Testing Environment
#'
#' @noRd

khis_cred_testing <- function() {
  khis_cred_internal('testing')
}

