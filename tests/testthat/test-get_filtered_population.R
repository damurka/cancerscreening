test_that("get_filtered_population works correct", {

  expect_error(get_filtered_population(), 'year')
  expect_error(get_filtered_population(2022), 'min_age')
  expect_error(get_filtered_population(2022, 5), 'max_age')
  expect_error(get_filtered_population(2022, 5, 34, level='invalid'), 'kenya')
  expect_no_error(get_filtered_population(2022, 5, 34, level='county'),)
  expect_error(get_filtered_population(2022, 5, 4, pop_sex='other'), 'female')
  expect_no_error(get_filtered_population(2022, 5, 4, pop_sex='both'))

  expect_error(
    get_filtered_population(c(2022, 2023), 5, 30),
    class = 'cancerscreening_invalid_numeric'
  )

  expect_error(
    get_filtered_population('2022', 5, 30),
    class = 'cancerscreening_invalid_numeric'
  )

  expect_error(
    get_filtered_population(2022, '5', 30),
    class = 'cancerscreening_invalid_numeric'
  )

  expect_error(
    get_filtered_population(2022, 5, '55'),
    class = 'cancerscreening_invalid_numeric'
  )
})
