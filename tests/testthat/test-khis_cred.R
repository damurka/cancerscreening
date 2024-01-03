test_that("khis_cred woks correctly using configuration file", {

  expect_error(khis_cred(), class = 'cancerscreening_missing_credentials')

  expect_error(
    khis_cred(config_path = 'creds.json', username = 'username'),
    class = 'cancerscreening_multiple_credentials'
  )

  expect_error(
    khis_cred(config_path ='does-not-exist.json'),
    class = 'cancerscreening_invalid_config_path'
  )

  expect_error(khis_cred(
    config_path = system.file("extdata", "empty_cred_conf.json", package = "cancerscreening")),
    class = 'cancerscreening_invalid_config_path'
  )

  expect_error(
    khis_cred(config_path = system.file("extdata", "blank_cred_conf.json", package = "cancerscreening")),
    class = 'cancerscreening_missing_credentials'
  )

  expect_error(
    khis_cred(config_path = '{ "credentials": {}}'),
    class = 'cancerscreening_missing_credentials'
  )

  expect_no_error(
    khis_cred(config_path = system.file("extdata", "valid_cred_conf.json", package = "cancerscreening"))
  )

  expect_true(khis_has_cred())

  expect_equal(khis_username(), 'username')

  khis_cred_clear()

  expect_false(khis_has_cred())
})

test_that("khis_cred woks correctly using username and password", {
  skip_on_cran()

  expect_no_error(khis_cred(username = 'username2', password = 'password2'))

  expect_true(khis_has_cred())

  expect_equal(khis_username(), 'username2')

  khis_cred_clear()
})

test_that("req_auth_khis_basic works correctly", {

  expect_error(
    httr2::request('https://example.com') %>% req_auth_khis_basic(),
    class = 'cancerscreening_missing_credentials'
  )

  khis_cred(config_path = system.file("extdata", "valid_cred_conf.json", package = "cancerscreening"))

  expect_no_error(httr2::request('https://example.com') %>% req_auth_khis_basic())

  khis_cred_clear()
})
