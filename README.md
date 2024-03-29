
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
head(cacx_screened)
#> # A tibble: 6 × 10
#>   period     value kenya category category2      element month  year fiscal_year
#>   <date>     <int> <chr> <fct>    <fct>          <fct>   <ord> <dbl> <fct>      
#> 1 2022-12-01    29 Kenya <25      Routine Scree… Pap Sm… Dece…  2022 2022/2023  
#> 2 2022-11-01    32 Kenya <25      Routine Scree… Pap Sm… Nove…  2022 2022/2023  
#> 3 2023-11-01     4 Kenya 25-49    Post-treatmen… Pap Sm… Nove…  2023 2023/2024  
#> 4 2022-10-01    46 Kenya <25      Routine Scree… Pap Sm… Octo…  2022 2022/2023  
#> 5 2023-10-01     2 Kenya 25-49    Post-treatmen… Pap Sm… Octo…  2023 2023/2024  
#> 6 2023-08-01  3304 Kenya <25      <NA>           VIA     Augu…  2023 2023/2024  
#> # ℹ 1 more variable: source <fct>
```

### Metadata reuse

When you need data from more than one function it is efficient to
download the metadata and share among the functions as shown below:

``` r
# Download the organisation units
organisations <- get_organisation_units_metadata()
head(organisations)
#> # A tibble: 6 × 10
#>   facility   kenya_id county_id subcounty_id ward_id facility_id ward  subcounty
#>   <chr>      <chr>    <chr>     <chr>        <chr>   <chr>       <chr> <chr>    
#> 1 10 Engine… HfVjCur… xuFdFy6t… pF6qPMIlHte  DpYpJ6… Vh676wb3d16 Nany… Laikipia…
#> 2 12 Engine… HfVjCur… qKzosKQP… YZAZ1a9MIvX  A7a1GZ… gPEGZGkfDWa Kame… Thika To…
#> 3 360 Healt… HfVjCur… wsBsC6gj… sr8WEz03EnP  FydnlJ… r96GaeVvrde Kadz… Nyali    
#> 4 3Keys Com… HfVjCur… wsBsC6gj… C1hO6wNOgrH  sHr1V6… lR6W5tK8hAq Junda Kisauni  
#> 5 3KR Healt… HfVjCur… ob6SxuRc… FBJ9Y11esHS  sJ50zp… CgMmkS9jWI6 Mene… Nakuru E…
#> 6 3rd Park … HfVjCur… jkG3zaih… f1T0Ltob8VQ  QhDd2L… a70eeTvT6tG Park… Westlands
#> # ℹ 2 more variables: county <chr>, kenya <chr>

# Download category options
categories <- get_category_options_metadata()
head(categories)
#> # A tibble: 6 × 2
#>   category_id category    
#>   <chr>       <chr>       
#> 1 iJYRsFhxyLb 0-1000cp//ml
#> 2 oCgj86VulzL 0-11 months 
#> 3 VXA6MsmIx6b 0-11 months 
#> 4 Awmk7Vfo6x5 0-11 months 
#> 5 C4f3Y9LnsRf 0-11 months 
#> 6 NqEtKTNqN3n 0-11 months

# Download data elements 
elements <- get_data_elements_metadata()
head(elements)
#> # A tibble: 6 × 2
#>   element                                                             element_id
#>   <chr>                                                               <chr>     
#> 1 ""                                                                  ioUhQ3uyR…
#> 2 "0000000 INCOME & EXPENDITURE STATEMENT"                            RvNJvXCx4…
#> 3 "1000000 Income/Revenue"                                            zo5v2sL2P…
#> 4 "10-14 Year-Old Girls"                                              dRhugDCan…
#> 5 "10.1 Residential"                                                  tZ3qTxyRK…
#> 6 "10.1 The facility has a sound fnancial plan that is adequately fu… oYdxcqRWR…

# Download cervical cancer screening data
cacx_screened <- get_cervical_screened('2021-07-01',
                                       end_date = '2021-12-31',
                                       level = 'county',
                                       elements = elements,
                                       categories = categories,
                                       organisations = organisations)
head(cacx_screened)
#> # A tibble: 6 × 10
#>   period     value county  category category2    element month  year fiscal_year
#>   <date>     <int> <chr>   <fct>    <fct>        <fct>   <ord> <dbl> <fct>      
#> 1 2021-08-01    25 Makueni 25-49    <NA>         HPV     Augu…  2021 2021/2022  
#> 2 2021-10-01    12 Kisii   50+      Initial Scr… Pap Sm… Octo…  2021 2021/2022  
#> 3 2021-11-01     8 Kilifi  <25      Initial Scr… VIA     Nove…  2021 2021/2022  
#> 4 2021-11-01     9 Kisii   50+      Initial Scr… Pap Sm… Nove…  2021 2021/2022  
#> 5 2021-10-01    18 Kilifi  <25      Initial Scr… VIA     Octo…  2021 2021/2022  
#> 6 2021-12-01     3 Kisii   50+      Initial Scr… Pap Sm… Dece…  2021 2021/2022  
#> # ℹ 1 more variable: source <fct>

# Download cervical cancer screening positives
cacx_positive <- get_cervical_positive('2021-07-01',
                                       end_date = '2021-12-31',
                                       level = 'county',
                                       elements = elements,
                                       categories = categories,
                                       organisations = organisations)
head(cacx_positive)
#> # A tibble: 6 × 10
#>   period     value county     category category2 element month  year fiscal_year
#>   <date>     <int> <chr>      <fct>    <fct>     <fct>   <ord> <dbl> <fct>      
#> 1 2021-09-01     1 Kisii      <25      <NA>      Suspic… Sept…  2021 2021/2022  
#> 2 2021-12-01     1 Kiambu     50+      Initial … VIA     Dece…  2021 2021/2022  
#> 3 2021-10-01     1 Kiambu     <25      <NA>      HPV     Octo…  2021 2021/2022  
#> 4 2021-10-01     1 Uasin Gis… 25-49    Initial … VIA     Octo…  2021 2021/2022  
#> 5 2021-08-01     2 Kilifi     25-49    Initial … Suspic… Augu…  2021 2021/2022  
#> 6 2021-09-01     1 Marsabit   <25      <NA>      HPV     Sept…  2021 2021/2022  
#> # ℹ 1 more variable: source <fct>

# Download Breast mammogram screening
breast_mammogram <- get_breast_mammogram('2021-07-01', 
                                         end_date = '2021-12-31',
                                         level = 'county',
                                         elements = elements,
                                         categories = categories,
                                         organisations = organisations)
head(breast_mammogram)
#> # A tibble: 6 × 9
#>   period     value county   category category2 element   month  year fiscal_year
#>   <date>     <int> <chr>    <fct>    <fct>     <fct>     <ord> <dbl> <fct>      
#> 1 2021-09-01     1 Nairobi  40-55    Abnormal  BIRADS 4  Sept…  2021 2021/2022  
#> 2 2021-11-01     1 Laikipia 40-55    Abnormal  BIRADS 6  Nove…  2021 2021/2022  
#> 3 2021-10-01     1 Laikipia 35-39    Normal    BIRADS 0… Octo…  2021 2021/2022  
#> 4 2021-10-01     3 Mombasa  40-55    Normal    BIRADS 0… Octo…  2021 2021/2022  
#> 5 2021-10-01     1 Nairobi  56-74    Normal    BIRADS 0… Octo…  2021 2021/2022  
#> 6 2021-10-01     2 Mombasa  40-55    Abnormal  BIRADS 4  Octo…  2021 2021/2022
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
