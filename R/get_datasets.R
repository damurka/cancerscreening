# TODO: Add the datasets

get_datasets <- function(dataset_id,
                         start_date,
                         end_date,
                         level = c('kenya', 'county', 'subcounty', 'ward', 'facility'),
                         organisations = NULL) {

  check_string_vector(dataset_id)
  check_date(start_date)
  check_date(end_date, can_be_null = TRUE)

  level <- arg_match(level)

  if (is.null(organisations)) {
    cancerscreening_bullets(c("i" = "Downloading organisation units"))
    organisations <- get_organisation_units_metadata()
  }
  organisations <- .filter_organisation_units(organisations, level)

  level <- switch (level,
                   kenya = 'LEVEL-1',
                   county = 'LEVEL-2',
                   subcounty = 'LEVEL-3',
                   ward = 'LEVEL-4',
                   facility = 'LEVEL-5')

  values <- c('REPORTING_RATE',
              'REPORTING_RATE_ON_TIME',
              'ACTUAL_REPORTS',
              'ACTUAL_REPORTS_ON_TIME',
              'EXPECTED_REPORTS')

  dx <- str_c(daset_id, values, sep = '.', collapse = ';')

  months_years <- seq(ymd(start_date), ymd(end_date), by = 'month')
  pe <- str_c(format(months_years, '%Y%m'), collapse = ';')

  data <- .api_get('analytics',
                   dimension = str_c('dx', dx, sep = ':'),
                   dimension = str_c('pe', pe, sep = ':'),
                   dimension = str_c('ou:',level, ';HfVjCurKxh2'),
                   skipData = FALSE,
                   skipMeta = TRUE,
                   ...
  )

  data <- tibble(x = data$rows) %>%
    unnest_wider(x, '') %>%
    rename(
      element = x1,
      period = x2,
      org_id = x3,
      value = x4
    ) %>%
    left_join(organisations, by = 'org_id', relationship = 'many-to-many') %>%
    mutate(
      element = case_when(
        str_detect(element, 'ACTUAL_REPORTS_ON_TIME') ~ 'actual_reports_on_time',
        str_detect(element, 'ACTUAL_REPORTS') ~ 'actual_reports',
        str_detect(element, 'EXPECTED_REPORTS') ~ 'expected_reports',
        str_detect(element, 'REPORTING_RATE_ON_TIME') ~ 'reporting_rate_on_time',
        str_detect(element, 'REPORTING_RATE') ~ 'reporting_rate',
      ),
      value = as.double(value)
    ) %>%
    pivot_wider(names_from = element, values_from = value, values_fill = 0)

  return(data)
}
