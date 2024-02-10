
# cancerscreening <a href="https://cancerscreening.damurka.com"><img src="man/figures/logo.png" align="right" height="139" alt="cancerscreening website" /></a>

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/cancerscreening)](https://CRAN.R-project.org/package=cancerscreening)
[![check-standard](https://github.com/damurka/cancerscreening/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/damurka/cancerscreening/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/damurka/cancerscreening/branch/main/graph/badge.svg)](https://app.codecov.io/gh/damurka/cancerscreening?branch=main)
<!-- badges: end -->

## Overview

cancerscreening provides an R interface to [Kenya Health Information
System (KHIS)](https://hiskenya.org) via the [DHIS 2
API](https://docs.dhis2.org/en/develop/using-the-api/dhis-core-version-master/introduction.html).
The goal of `cancerscreening` is to provide a easy way to download
cancer screening data from the KHIS using R.

## Installation

You can install the released version of cancerscreening from
[CRAN](https://cran.r-project.org/) with:

``` r
install.packages("cancerscreening")
```

And the development version of from [Github](https://github.com) with:

``` r
# install.packages("pak")
pak::pak('damurka/cancerscreening')
```

## Usage

### Load cancerscreening package

``` r
library("cancerscreening")
```

### Auth

cancerscreening will, by default, help you interact with KHIS as an
authenticated user. Before calling any function that makes an API call
you need credentials to [KHIS](https://hiskenya.org). You will be
expected to set this credential to download the data. See the article
[set you
credentials](https://cancerscreening.damurka.com/articles/set-your-credentials.html)
for more

``` r
# Set the credentials using username and password
khis_cred(username = 'KHIS username', password = 'KHIS password')

# Set credentials using configuration path
khis_cred(config_path = 'path/to/secret.json')
```

After setting the credential you can invoke any function to download
data from the API.

For this overview, we’ve logged into KHIS as a specific user in a hidden
chunk.

### Package conventions

- Most function begin with the prefix `get_` followed by the screening
  area `cervical`, `breast`, or `colorectal`. Auto-completion is your
  friend
- Goal is to allow the download of data associated with the data of
  interest, e.g. `get_cervical_screened`, `get_cervical_positive`, or
  `get_cervical_treated`
- cancerscreening is “pipe-friendly” and, in-fact re-exports `%>%` but
  does not require its use.

This is a basic example which shows you how to solve a common problem:

``` r
# Download the cervical cancer screening data for country
cacx_screened <- get_cervical_screened('2022-07-01')
cacx_screened
#> # A tibble: 619 × 10
#>    value country element   category period     month  year fiscal_year age_group
#>    <dbl> <chr>   <fct>     <fct>    <date>     <ord> <dbl> <fct>       <fct>    
#>  1   966 Kenya   Pap Smear Initial… 2023-04-01 April  2023 2022/2023   25-49    
#>  2    89 Kenya   HPV       Routine… 2024-01-01 Janu…  2024 2023/2024   25-49    
#>  3  1057 Kenya   Pap Smear Initial… 2023-05-01 May    2023 2022/2023   25-49    
#>  4  1066 Kenya   Pap Smear Initial… 2023-03-01 March  2023 2022/2023   25-49    
#>  5    22 Kenya   VIA       Post-tr… 2022-08-01 Augu…  2022 2022/2023   <25      
#>  6     1 Kenya   VIA       Post-tr… 2022-07-01 July   2022 2022/2023   <25      
#>  7   632 Kenya   Pap Smear Initial… 2023-08-01 Augu…  2023 2023/2024   25-49    
#>  8     3 Kenya   HPV       Routine… 2022-07-01 July   2022 2022/2023   <25      
#>  9   647 Kenya   Pap Smear Initial… 2023-07-01 July   2023 2023/2024   25-49    
#> 10  1254 Kenya   VIA       Initial… 2023-09-01 Sept…  2023 2023/2024   50+      
#> # ℹ 609 more rows
#> # ℹ 1 more variable: source <fct>
```

### Metadata reuse

When you need data from more than one function it is efficient to
download the metadata and share among the functions as shown below:

``` r
# Download the organisation units
organisations <- get_organisation_units_metadata(level = 'county')
organisations
#> # A tibble: 47 × 3
#>    county          id          country
#>    <chr>           <chr>       <chr>  
#>  1 Baringo         vvOK1BxTbet Kenya  
#>  2 Bomet           HMNARUV2CW4 Kenya  
#>  3 Bungoma         KGHhQ5GLd4k Kenya  
#>  4 Busia           Tvf1zgVZ0K4 Kenya  
#>  5 Elgeyo Marakwet MqnLxQBigG0 Kenya  
#>  6 Embu            PFu8alU2KWG Kenya  
#>  7 Garissa         uyOrcHZBpW0 Kenya  
#>  8 Homa Bay        nK0A12Q7MvS Kenya  
#>  9 Isiolo          bzOfj0iwfDH Kenya  
#> 10 Kajiado         Hsk1YV8kHkT Kenya  
#> # ℹ 37 more rows

# Download cervical cancer screening data
cacx_screened <- get_cervical_screened('2021-07-01',
                                       end_date = '2021-12-31',
                                       level = 'county',
                                       organisations = organisations)
cacx_screened
#> # A tibble: 2,781 × 11
#>    value county      country element category period     month  year fiscal_year
#>    <dbl> <chr>       <chr>   <fct>   <fct>    <date>     <ord> <dbl> <fct>      
#>  1     1 Bungoma     Kenya   VIA     Initial… 2021-08-01 Augu…  2021 2021/2022  
#>  2    32 Bomet       Kenya   VIA     <NA>     2021-09-01 Sept…  2021 2021/2022  
#>  3     1 Kitui       Kenya   Pap Sm… Routine… 2021-09-01 Sept…  2021 2021/2022  
#>  4     2 Kiambu      Kenya   Pap Sm… Initial… 2021-08-01 Augu…  2021 2021/2022  
#>  5     2 Elgeyo Mar… Kenya   VIA     <NA>     2021-11-01 Nove…  2021 2021/2022  
#>  6     3 Nandi       Kenya   VIA     <NA>     2021-07-01 July   2021 2021/2022  
#>  7    68 Migori      Kenya   VIA     <NA>     2021-12-01 Dece…  2021 2021/2022  
#>  8    17 Meru        Kenya   VIA     Initial… 2021-11-01 Nove…  2021 2021/2022  
#>  9     2 Nyeri       Kenya   Pap Sm… <NA>     2021-12-01 Dece…  2021 2021/2022  
#> 10    75 Nairobi     Kenya   Pap Sm… <NA>     2021-10-01 Octo…  2021 2021/2022  
#> # ℹ 2,771 more rows
#> # ℹ 2 more variables: age_group <fct>, source <fct>

# Download cervical cancer screening positives
cacx_positive <- get_cervical_positive('2021-07-01',
                                       end_date = '2021-12-31',
                                       level = 'county',
                                       organisations = organisations)
cacx_positive
#> # A tibble: 1,600 × 11
#>    value county      country element category period     month  year fiscal_year
#>    <dbl> <chr>       <chr>   <fct>   <fct>    <date>     <ord> <dbl> <fct>      
#>  1     1 Bomet       Kenya   HPV     <NA>     2021-12-01 Dece…  2021 2021/2022  
#>  2     5 Kakamega    Kenya   Suspic… <NA>     2021-11-01 Nove…  2021 2021/2022  
#>  3     1 Bungoma     Kenya   Suspic… Initial… 2021-12-01 Dece…  2021 2021/2022  
#>  4     2 Machakos    Kenya   VIA     Routine… 2021-07-01 July   2021 2021/2022  
#>  5    12 Kirinyaga   Kenya   VIA     Initial… 2021-09-01 Sept…  2021 2021/2022  
#>  6     3 Trans Nzoia Kenya   Pap Sm… Initial… 2021-10-01 Octo…  2021 2021/2022  
#>  7     1 Bomet       Kenya   Pap Sm… <NA>     2021-09-01 Sept…  2021 2021/2022  
#>  8     6 Busia       Kenya   VIA     <NA>     2021-09-01 Sept…  2021 2021/2022  
#>  9     4 Nakuru      Kenya   Suspic… <NA>     2021-10-01 Octo…  2021 2021/2022  
#> 10    12 Kisii       Kenya   VIA     <NA>     2021-11-01 Nove…  2021 2021/2022  
#> # ℹ 1,590 more rows
#> # ℹ 2 more variables: age_group <fct>, source <fct>

# Download Breast mammogram screening
breast_mammogram <- get_breast_mammogram('2021-07-01', 
                                         end_date = '2021-12-31',
                                         level = 'county',
                                         organisations = organisations)
breast_mammogram
#> # A tibble: 21 × 11
#>    value county    country element  age_group period     month  year fiscal_year
#>    <dbl> <chr>     <chr>   <fct>    <fct>     <date>     <ord> <dbl> <fct>      
#>  1     1 Laikipia  Kenya   BIRADS … 56-74     2021-10-01 Octo…  2021 2021/2022  
#>  2     1 Kakamega  Kenya   BIRADS 4 56-74     2021-09-01 Sept…  2021 2021/2022  
#>  3    15 Nairobi   Kenya   BIRADS … 25-34     2021-07-01 July   2021 2021/2022  
#>  4     2 Kirinyaga Kenya   BIRADS … 40-55     2021-12-01 Dece…  2021 2021/2022  
#>  5     1 Nairobi   Kenya   BIRADS 4 40-55     2021-09-01 Sept…  2021 2021/2022  
#>  6     1 Nairobi   Kenya   BIRADS … 56-74     2021-10-01 Octo…  2021 2021/2022  
#>  7     1 Nairobi   Kenya   BIRADS 6 56-74     2021-12-01 Dece…  2021 2021/2022  
#>  8     1 Laikipia  Kenya   BIRADS … 35-39     2021-10-01 Octo…  2021 2021/2022  
#>  9     1 Machakos  Kenya   BIRADS … 40-55     2021-11-01 Nove…  2021 2021/2022  
#> 10     7 Nairobi   Kenya   BIRADS … 40-55     2021-10-01 Octo…  2021 2021/2022  
#> # ℹ 11 more rows
#> # ℹ 2 more variables: source <chr>, category <fct>
```

## Where to learn more

[Get
Started](https://cancerscreening.damurka.com/articles/cancerscreening.html)
is a more extensive general introduction to cancerscreening.

Browse the [articles
index](https://cancerscreening.damurka.com/articles/index.html) to find
articles that cover various topics in more depth.

See the [function
index](https://cancerscreening.damurka.com/reference/index.html) for an
organized, exhaustive listing.

## Code of Conduct

Please note that the cancerscreening project is released with a
[Contributor Code of
Conduct](https://cancerscreening.damurka.com/CODE_OF_CONDUCT.html). By
contributing to this project, you agree to abide by its terms.
