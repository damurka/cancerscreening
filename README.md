
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
#> # A tibble: 6 × 2
#>   county          target
#>   <fct>            <dbl>
#> 1 Baringo         12705.
#> 2 Bomet           18680.
#> 3 Bungoma         33151.
#> 4 Busia           18221.
#> 5 Elgeyo Marakwet  9093.
#> 6 Embu            15342.

# Download the cervical cancer screening data by county
data <- get_cervical_screened('2022-07-01', end_date = '2022-12-31', level = 'county')
data
#> # A tibble: 3,081 × 10
#>    period     value county    category category2 element month  year fiscal_year
#>    <date>     <int> <chr>     <fct>    <fct>     <fct>   <ord> <dbl> <fct>      
#>  1 2022-12-01    24 Tharaka … 25-49    Routine … VIA     Dece…  2022 2022/2023  
#>  2 2022-11-01     2 Tharaka … 25-49    Routine … VIA     Nove…  2022 2022/2023  
#>  3 2022-12-01     6 Makueni   <25      Routine … VIA     Dece…  2022 2022/2023  
#>  4 2022-10-01     6 Tharaka … 25-49    Routine … VIA     Octo…  2022 2022/2023  
#>  5 2022-10-01    31 Makueni   <25      Routine … VIA     Octo…  2022 2022/2023  
#>  6 2022-11-01    20 Makueni   <25      Routine … VIA     Nove…  2022 2022/2023  
#>  7 2022-09-01    10 Makueni   25-49    Initial … HPV     Sept…  2022 2022/2023  
#>  8 2022-09-01     1 Kwale     <25      Initial … Pap Sm… Sept…  2022 2022/2023  
#>  9 2022-12-01     1 Bungoma   25-49    <NA>      HPV     Dece…  2022 2022/2023  
#> 10 2022-11-01     1 Bungoma   25-49    <NA>      HPV     Nove…  2022 2022/2023  
#> # ℹ 3,071 more rows
#> # ℹ 1 more variable: source <fct>

# To learn more about the function, run the following command
?get_cervical_screened
```

## Code of Conduct

Please note that the cancerscreening project is released with a
[Contributor Code of
Conduct](https://cancerscreening.damurka.com/CODE_OF_CONDUCT.html). By
contributing to this project, you agree to abide by its terms.
