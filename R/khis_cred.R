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
#'
#' @return No return value
#'
#' @export
#'
#' @details
#' When `username` and `password` are provided they are persisted to the operating
#' system’s credential store using [keyring] package. Subsequent call will only
#' require the `username`. If the password has not been store a prompt for the
#' password will appear
#'
#'
#' @examples
#' # These examples use the default keyring, and they are interactive,
#' # so, we don't run them by default
#' \dontrun{
#'   # Load username and password
#'   khis_cred(username = 'khis_username', password = 'PASSWORD')
#' }

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

    if (!rlang::is_scalar_character(password) || nchar(password) == 0 || !rlang::is_scalar_character(username) || nchar(username) == 0) {
      cancerscreening_abort(
        message = c(
          "x" = "Missing credentials",
          "i" = "Please provide username and password to continue"
        ),
        class = "cancerscreening_missing_credentials"
      )
    }
  } else {
    password <- ifelse(!rlang::is_scalar_character(password), "", password)
    khis_service <- 'khis-service'
    khis_package <- 'cancerscreening'

    kb <- keyring::default_backend(khis_package)

    # checks if keyring, and if not there prompts to make one
    if (nchar(password) == 0) {
      password <- tryCatch(
        kb$get(khis_service, username, khis_package),
        error = function(e) e
      )
      if ('error' %in% class(password)) {
        kb$set(khis_service, username, khis_package)
        password <- kb$get(khis_service, username, khis_package)
      }
    }

    kb$set_with_value(khis_service, username, password, khis_package)
  }

  .auth$set_username(username)
  .auth$set_password(password)

  cancerscreening_bullets(c("i" = 'The credentials have been set.'))

  invisible(NULL)
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
#'
#' @return a boolean value indicating if the credentials are available
#'
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
#' @return No return value
#' @export
#'
#' @examples
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
#' @examples
#'
#' # View the username
#' khis_username()

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
#' @return No return value
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

