
# cancerscreening <a href="https://cancerscreening.damurka.com"><img src="man/figures/logo.png" align="right" height="139" alt="cancerscreening website" /></a>

<!-- badges: start -->

[![check-standard](https://github.com/damurka/cancerscreening/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/damurka/cancerscreening/actions/workflows/R-CMD-check.yaml)
[![test-coverage](https://github.com/damurka/cancerscreening/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/damurka/cancerscreening/actions/workflows/test-coverage.yaml)
[![pkgdown](https://github.com/damurka/cancerscreening/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/damurka/cancerscreening/actions/workflows/pkgdown.yaml)
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
# install.packages("pak")
pak::pak('damurka/cancerscreening')
```

***Note: This package is not yet available on CRAN.***

## Usage

Please see the package website: <https://cancerscreening.damurka.com>

This is a basic example which shows you how to solve a common problem:

``` r
# Load the package
library(cancerscreening)

# Set credential to make API calls to KHIS
khis_cred(username = 'KHIS Username')

# Get cervical cancer screening target population by county
target <- get_cervical_target_population(year = 2023, level = 'county')

# Download the cervical cancer screening data by county
data <- get_cervical_screened('2022-07-01', level = 'county')

# To learn more about the function, run the following command
?get_cervical_screened
```

## Code of Conduct

Please note that the cancerscreening project is released with a
[Contributor Code of
Conduct](https://cancerscreening.damurka.com/CODE_OF_CONDUCT.html). By
contributing to this project, you agree to abide by its terms.
