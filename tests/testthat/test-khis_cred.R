test_that("khis_cred woks correctly", {

  expect_error(khis_cred(), "Pass credential through config path or username", fixed = TRUE)

  expect_error(khis_cred(config_path = 'creds.json', username = 'username'), "If using config_path then username can not be passed in directly", fixed = TRUE)
})
