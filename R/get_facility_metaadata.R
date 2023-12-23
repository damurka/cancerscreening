#' Get the facility ownership metadata
#'
#' \code{get_facility_ownerships} function retrieves the facility ownership metadata
#'
#' @return A tibble containing a list of facility ownership metadata
#' \describe{
#'    \item{ownership_id}{unique identifier for the data element}
#'    \item{facility_ownership}{name of the data element}
#' }
#'
#' @export

get_facility_ownerships <- function() {
  ## ORGANISATION_UNIT_GROUP
  ## JlW9OiK1eR4 - Facility Ownership
  # eT1vvFVhLHc - Faith Based Organisation
  # AaAF5EmS1fk - Ministry of Health
  # aRxa6o8GqZN - Private
  # facility_ownership <- 'JlW9OiK1eR4:eT1vvFVhLHc;AaAF5EmS1fk;aRxa6o8GqZN'

  tibble(
    ownership_id = c('eT1vvFVhLHc', 'AaAF5EmS1fk', 'aRxa6o8GqZN'),
    facility_ownership = c('Faith Based Organisation', 'Ministry of Health', 'Private')
  )
}

#' Get the facility Kenya essential package for Health (KEPH) level metadata
#'
#' \code{get_keph_levels} function retrieves the facility KEPH level metadata
#'
#' @return A tibble containing a list of facility KEPH level metadata
#' \describe{
#'    \item{keph_id}{unique identifier for the data element}
#'    \item{keph_level}{name of the data element}
#' }
#'
#' @export

get_keph_levels <- function() {
  ## ORGANISATION_UNIT_GROUP
  ## sytI3XYbxwE - KEPH Level
  # axUnguN4QDh - KEPH Level 1
  # tvMxZ8aCVou - KEPH Level 2
  # wwiu1jyZOXO - KEPH Level 3
  # hBZ5DRto7iF - KEPH Level 4
  # d5QX71PY5t0 - KEPH Level 5
  # FpY8vg4gh46 - KEPH Level 6
  # keph_level <- 'sytI3XYbxwE:axUnguN4QDh;tvMxZ8aCVou;wwiu1jyZOXO;hBZ5DRto7iF;d5QX71PY5t0;FpY8vg4gh46'

  tibble(
    keph_id = c('axUnguN4QDh', 'tvMxZ8aCVou', 'wwiu1jyZOXO', 'hBZ5DRto7iF', 'd5QX71PY5t0', 'FpY8vg4gh46'),
    keph_level = c('Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5', 'Level 6')
  )
}

#' Get the facility type metadata
#'
#' \code{get_facility_types} function retrieves the facility type metadata
#'
#' @return A tibble containing a list of facility type metadata
#' \describe{
#'    \item{type_id}{unique identifier for the data element}
#'    \item{facility_type}{name of the data element}
#' }
#'
#' @export

get_facility_types <- function() {

  ## ORGANISATION_UNIT_GROUP
  ## FSoqQFDES0U - Facility Type
  # mVrepdLAqSD - Revised Dispensary (2018)
  # rhKJPLo27x7 - Revised Health Centre (2018)
  # CGDNIWGHRNr - Revised Hospital (2018)
  # xKv918PvmHN - Revised Medical Center (2018)
  # lTrpyOiOcM6 - Revised Medical Clinic (2018)
  # lQXBYwznvXA - Revised Nursing Home (2018)
  # YQK9pleIoeB - Revised Stand alone(2018)
  # facility_type <- 'FSoqQFDES0U:mVrepdLAqSD;rhKJPLo27x7;CGDNIWGHRNr;xKv918PvmHN;lTrpyOiOcM6;lQXBYwznvXA;YQK9pleIoeB'

  tibble(
    type_id = c('mVrepdLAqSD','rhKJPLo27x7','CGDNIWGHRNr','xKv918PvmHN','lTrpyOiOcM6','lQXBYwznvXA','YQK9pleIoeB'),
    facility_type = c('Dispensary','Health Centre','Hospital','Medical Centre','Medical Clinic','Nursing Home','Stand alone')
  )
}
