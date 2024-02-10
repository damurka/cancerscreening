# TODO: Add the datasets

get_datasets <- function(dataset_ids,
                         start_date,
                         end_date,
                         level = c('country', 'county', 'subcounty', 'ward', 'facility'),
                         organisations = NULL) {

  dx = pe = ou = element = value = NULL # due to NSE notes in R CMD check

  check_string_vector(dataset_ids)
  check_date(start_date)
  check_date(end_date, can_be_null = TRUE)

  level <- arg_match(level)
  ou_level <- switch (level,
                   country = 'LEVEL-1',
                   county = 'LEVEL-2',
                   subcounty = 'LEVEL-3',
                   ward = 'LEVEL-4',
                   facility = 'LEVEL-5')

  values <- c('REPORTING_RATE',
              'REPORTING_RATE_ON_TIME',
              'ACTUAL_REPORTS',
              'ACTUAL_REPORTS_ON_TIME',
              'EXPECTED_REPORTS')

  dataset_ids <- str_c(dataset_ids, values, sep = '.')
  periods <- seq(ymd(start_date), ymd(end_date), by = 'month')

  data <- get_analytics(
    dx %.d% dataset_ids,
    pe %.d% periods,
    ou %.d% c(ou_level, 'HfVjCurKxh2')
  )

  if (is.null(organisations)) {
    cancerscreening_bullets(c("i" = "Downloading organisation units"))
    organisations <- get_organisation_units_metadata(id %.in% data$ou, level = level)
  }

  data <- data %>%
    left_join(organisations, by = 'id', relationship = 'many-to-many') %>%
    mutate(
      element = case_when(
        str_detect(element, 'ACTUAL_REPORTS_ON_TIME') ~ 'actual_reports_on_time',
        str_detect(element, 'ACTUAL_REPORTS') ~ 'actual_reports',
        str_detect(element, 'EXPECTED_REPORTS') ~ 'expected_reports',
        str_detect(element, 'REPORTING_RATE_ON_TIME') ~ 'reporting_rate_on_time',
        str_detect(element, 'REPORTING_RATE') ~ 'reporting_rate',
      )
    ) %>%
    pivot_wider(names_from = element, values_from = value, values_fill = 0)

  return(data)
}
