test_that("get_analytics works correctly", {
  skip_if_no_cred()
  skip_if_offline()

  element_id = c('cXe64Yk0QMY', 'XEX93uLsAm2')

  expect_error(get_analytics(), "element_ids")

  expect_error(get_analytics(element_ids = element_id), "start_date")

  expect_error(
    get_analytics(element_ids = list()),
    class = 'cancerscreening_missing_argument'
  )

  expect_error(
    get_analytics(element_ids = element_id, start_date = '1234'),
    class = 'cancerscreening_incorrect_date_format'
  )

  expect_error(
    get_analytics(element_ids = element_id, start_date = c('2022-01-01', '2021-01-01')),
    class = 'cancerscreening_incorrect_date_format'
  )

  expect_error(
    get_analytics(element_ids = element_id, start_date = '2022-01-01', end_date = '1234'),
    class = 'cancerscreening_incorrect_date_format'
  )

  expect_error(
    get_analytics(element_ids = element_id, start_date = '2020-01-01', level = 'other'),
    "kenya"
  )

  expect_no_error(
    get_analytics(element_ids = element_id, start_date = '2023-07-01')
  )

})
