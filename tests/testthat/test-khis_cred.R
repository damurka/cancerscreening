test_that("khis_cred woks correctly", {

  expect_error(khis_cred(), "Pass credential through config path or username", fixed = TRUE)

  expect_error(khis_cred(config_path = 'creds.json', username = 'username'), "If using config_path then username can not be passed in directly", fixed = TRUE)

  expect_error(khis_cred(config_path ='does-not-exist.json'), "Invalid config_path.", fixed = TRUE)

  expect_error(khis_cred(
    config_path = system.file("extdata", "empty_cred_conf.json", package = "cancerscreening")),
    'config_path is not in the correct format',
    fixed = TRUE)

  expect_error(khis_cred(
    config_path = system.file("extdata", "blank_cred_conf.json", package = "cancerscreening")),
    "Configuration must contain username and password",
    fixed = TRUE)

  expect_error(
    khis_cred(config_path = '{ "credentials": {}}'),
    "Configuration must contain username and password",
    fixed = TRUE)

  expect_no_error(
    khis_cred(
      config_path = system.file("extdata", "valid_cred_conf.json", package = "cancerscreening"))
  )

  expect_true(khis_has_cred())

  expect_equal(khis_username(), 'username')

  khis_cred_clear()

  expect_false(khis_has_cred())

  expect_no_error(khis_cred(username = 'username2', password = 'password2'))

  expect_true(khis_has_cred())

  expect_equal(khis_username(), 'username2')

  khis_cred_clear()
})

test_that("req_auth_khis_basic works correctly", {

  expect_error(
     req_auth_khis_basic(httr2::request('https://example.com')),
    'You have not set KHIS credential. Call khis_cred to set.',
    fixed = TRUE)

  khis_cred(config_path = system.file("extdata", "valid_cred_conf.json", package = "cancerscreening"))

  expect_no_error(req_auth_khis_basic(httr2::request('https://example.com')))

  khis_cred_clear()
})
