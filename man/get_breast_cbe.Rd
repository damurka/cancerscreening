% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_breast_cbe.R
\name{get_breast_cbe}
\alias{get_breast_cbe}
\title{Retrieves Data for Clinical Breast Examinations (CBE) Conducted}
\usage{
get_breast_cbe(
  start_date,
  end_date = NULL,
  level = c("country", "county", "subcounty", "ward", "facility"),
  organisations = NULL,
  ...
)
}
\arguments{
\item{start_date}{The start date to retrieve data. It is required and in the format \code{YYYY-MM-dd}.}

\item{end_date}{The ending date for data retrieval (default is the current date).}

\item{level}{The desired data granularity: \code{"country"} (the default), \code{"county"}, \code{"subcounty"}, \code{"ward"}, or \code{"facility"}.}

\item{organisations}{A list of organization units ids to be filtered.}

\item{...}{Other options that can be passed onto KHIS API.}
}
\value{
A tibble containing data for CBE conducted with the following columns:
\itemize{
\item country    - Name of the country country
\item county     - Name of the county. Optional if the level is \code{county}, \code{subcounty}, \code{ward} or \code{facility}.
\item subcounty  - Name of the subcounty. Optional if the level is \code{subcounty}, \code{ward} or \code{facility}.
\item ward       - Name of the ward. Optional if the level is \code{ward} or \code{facility}.
\item facility   - Name of the health facility. Optional if the level \code{facility}.
\item period     - The month and year of the data.
\item fiscal_year- The financial year of the report(July-June Cycle).
\item year       - The calendar year of the report.
\item month      - The month name of the report.
\item age_group  - The age group category of the report (25-34, 35-39, 40-55, 56-74, or 75+).
\item category   - Additional category if available.
\item element    - The data element.
\item value      - The number reported.
}
}
\description{
\code{get_breast_cbe()} retrieves data for CBE conducted within a specified
period from the KHIS API server.
}
\examples{
\dontshow{if (khis_has_cred()) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
# Download data from February 2023 to current date
cbe_data <- get_breast_cbe(start_date = '2023-02-01')
cbe_data
\dontshow{\}) # examplesIf}
}
