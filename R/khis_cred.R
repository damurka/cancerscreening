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
#' # Load from a configuration file
#' khis_cred(config_path = 'cred.json')
#'
#' # Load username and password
#' khis_cred(username = 'damurka', password = 'PASSWORD')
#'
#' # Load if the password has been used before
#' khis_cred(username = 'damurka')
khis_cred <- function(config_path = NULL,
                      username = NULL,
                      password = NULL) {
  if (is.null(config_path) && is.null(username)) {
    stop("Pass credential through config path or username")
  }

  if (!(is.null(config_path)) && !(is.null(username))) {
    stop("If using config_path then credentials can not be passed in directly")
  }

  if (!is.null(config_path)) {
    # loads credentials from secret file
    credentials <- .load_config_file(config_path = config_path)
    password <- credentials[["password"]]
    username <- credentials[["username"]]

    if (is.null(password) || is.null(username)) {
      stop('Config file must contain username and password')
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
  if (!is.na(config_path)) {
    data <- jsonlite::fromJSON(config_path)
    return(data[['credentials']])
  } else {
    stop("You must specify a credentials file!")
  }
}

#' Authenticate Request with HTTP Basic Authentication
#'
#' This sets the Authorization header for basic authentication using the username and password provided.
#'
#' @param req A request
#'
#' @return A modified HTTP request with authorization header
#'
#' @keywords internal
#'
#' @examplesIf khis_has_cred()
#' req <- request("http://example.com") |> req_auth_khis_basic("damurka", "PASSWORD")
#' req
#'
#' @seealso [httr2]

req_auth_khis_basic <- function(req) {
  if (!khis_has_cred()) {
    #khis_cred()
    stop("You are not logged into KHIS")
  }
  httr2::req_auth_basic(req, .auth$username, .auth$password)
}

#' Are There Credentials on Hand?
#'
#' @family low-level API functions
#' @export
#'
#' @examples
#' khis_has_cred()

khis_has_cred <- function() {
  .auth$has_cred()
}

#' Internal Credentials
#'
#' Internal function used to provide credentials for the testing and documentation
#'   environment
#'
#' @param account The environment to provide credentials. `"docs"` or `"testing"`
#'
#' @importFrom gargle secret_has_key
#'
#' @keywords internal

khis_cred_internal <- function(account = c('docs', 'testing')) {
  account <- match.arg(account)
  can_decrypt <- secret_has_key('CANCERSCREENING_KEY')
  online <- !is.null(curl::nslookup('hiskenya.org', error = FALSE))
  if (!can_decrypt || !online) {
    cli::cli_abort(message = c(
      "Auth unsuccessful:",
      if (!can_decrypt) {
        c("x" = "Can't decrypt the {.field {account}} service account token.")
      },
      if (!online) {
        c("x" = "We don't appear to be online. Or maybe the Drive API is down?")
      }
    ),
    class = "cancerscreening_cred_internal_error",
    can_decrypt = can_decrypt,
    online = online,
    .envir = parent.frame())
  }

  filename <- str_glue("cancerscreening-{account}.json")
  khis_cred(
    config_path = gargle::secret_decrypt_json(
      system.file('secret', filename, package = 'cancerscreening'),
      'CANCERSCREENING_KEY'
    )
  )
  invisible(TRUE)
}

#' Set Credentials for Documentation
#'
#' @keywords internal

khis_cred_docs <- function() {
  khis_cred_internal('docs')
}

#' Set Credentials for Testing Environment
#'
#' @keywords internal
khis_cred_testing <- function() {
  khis_cred_internal('testing')
}

