#' Facility Ownership Metadata
#'
#' Provides the facility ownership metadata.
#'
#' @details
#' The data will contain the following info about the facility ownership organisation unit group
#'   * JlW9OiK1eR4 - Facility Ownership
#'   * eT1vvFVhLHc - Faith Based Organisation
#'   * AaAF5EmS1fk - Ministry of Health
#'   * aRxa6o8GqZN - Private
#'
#' @format A tibble with 2 columns and 4 rows
#'
#' * ownership_id - unique identifier for the data element.
#' * facility_ownership - name of the data element.
#'
#' @source Kenya Health Information System <https://hiskenya.org>
#'
#' @keywords internal
#' "facility_ownership"

#' Kenya essential package for Health (KEPH) Level Metadata
#'
#' Provided the facility KEPH level metadata.
#'
#' @details
#' The data will contain the following info about the KEPH organisation unit group
#'   * sytI3XYbxwE - KEPH Level
#'   * axUnguN4QDh - KEPH Level 1
#'   * tvMxZ8aCVou - KEPH Level 2
#'   * wwiu1jyZOXO - KEPH Level 3
#'   * hBZ5DRto7iF - KEPH Level 4
#'   * d5QX71PY5t0 - KEPH Level 5
#'   * FpY8vg4gh46 - KEPH Level 6
#'
#' @format A tibble with 2 columns and 6 rows
#'
#' * keph_id    - unique identifier for the data element
#' * keph_level - name of the data element
#'
#' @source Kenya Health Information System <https://hiskenya.org>
#'
#' @keywords internal
#' "keph_level"

#' Facility Type Metadata
#'
#' Provides the facility type metadata.
#'
#' @details
#' The data will contain the following info about the facility type organisation unit group
#'   * FSoqQFDES0U - Facility Type
#'   * mVrepdLAqSD - Revised Dispensary (2018)
#'   * rhKJPLo27x7 - Revised Health Centre (2018)
#'   * CGDNIWGHRNr - Revised Hospital (2018)
#'   * xKv918PvmHN - Revised Medical Center (2018)
#'   * lTrpyOiOcM6 - Revised Medical Clinic (2018)
#'   * lQXBYwznvXA - Revised Nursing Home (2018)
#'   * YQK9pleIoeB - Revised Stand alone(2018)
#'
#' @format A tibble with 2 columns and 7 rows
#'
#' * type_id        - unique identifier for the data element
#' * facility_type  - name of the data element
#'
#' @source Kenya Health Information System <https://hiskenya.org>
#'
#' @keywords internal
#' "facility_type"

#' Population Data from KNBS Census
#'
#' Provides population statistics for counties and subcounties in Kenya, as per Volume 3 of the 2019 Kenya Population and Housing Census Table 2.3
#'
#' @format A tibble with 54 rows and 4 variables:
#'
#' * county     - Character vector of county names.
#' * subcounty  - Character vector of subcounty names.
#' * age        - The age distribution.
#' * sex        - The sex of the population.
#' * population - The number of this population.
#'
#' @source
#' Kenya National Bureau of Statistics (KNBS), 2019 Kenya Population and Housing Census Volume III: Distribution of populayion by Age, Sex and Administtrative units
#' <https://www.knbs.or.ke/download/2019-kenya-population-and-housing-census-volume-iii-distribution-of-population-by-age-sex-and-administrative-units/>
#'
#' @keywords internal
#' "population_data"
