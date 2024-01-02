
    Code chunks will not be evaluated, because:
    Set cred unsuccessful:

# cancerscreening <a href="https://cancerscreening.damurka.com"><img src="man/figures/logo.png" align="right" height="139" alt="cancerscreening website" /></a>

<!-- badges: start -->

[![check-standard](https://github.com/damurka/cancerscreening/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/damurka/cancerscreening/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/damurka/cancerscreening/branch/main/graph/badge.svg)](https://app.codecov.io/gh/damurka/cancerscreening?branch=main)
<!-- badges: end -->

## Overview

The goal of `cancerscreening` is to provide a easy way to download
cancer screening data from the Kenya Health Information System (KHIS)
using R.

## Installation

You can install the released version of cancerscreening from
[CRAN](https://cran.r-project.org/) with:

``` r
install.packages("cancerscreening")
```

You can install the development version of from
[Github](https://github.com) with:

``` r
# install.packages("devtools")
devtools::install_github('damurka/cancerscreening')
```

***Note: This package is not yet available on CRAN.***

## Usage

Please see the package website: <https://cancerscreening.damurka.com>

This is a basic example which shows you how to solve a common problem:

``` r
# Load the package
library(cancerscreening)

# Set credential to make API calls to KHIS
# khis_cred(username = 'KHIS Username')

# Get cervical cancer screening target population by county
target <- get_cervical_target_population(year = 2023, level = 'county')
head(target)

# Download the cervical cancer screening data by county
data <- get_cervical_screened('2022-07-01', end_date = '2022-12-31', level = 'county')
data

# To learn more about the function, run the following command
?get_cervical_screened
```

## Code of Conduct

Please note that the cancerscreening project is released with a
[Contributor Code of
Conduct](https://cancerscreening.damurka.com/CODE_OF_CONDUCT.html). By
contributing to this project, you agree to abide by its terms.
