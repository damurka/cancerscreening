
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
cancer screening data from the KHIS using the (khisr
package)\[<https://khisr.damurka.com>\].

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
  area `cervical`, `breast`, `colorectal`, or `lab`. Auto-completion is
  your friend
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
#> # A tibble: 689 × 10
#>    value country element   category period     month  year fiscal_year age_group
#>  * <dbl> <chr>   <fct>     <fct>    <date>     <ord> <dbl> <fct>       <fct>    
#>  1   971 Kenya   Pap Smear Initial… 2023-04-01 April  2023 2022/2023   25-49    
#>  2   106 Kenya   HPV       Routine… 2024-01-01 Janu…  2024 2023/2024   25-49    
#>  3  1060 Kenya   Pap Smear Initial… 2023-05-01 May    2023 2022/2023   25-49    
#>  4  1068 Kenya   Pap Smear Initial… 2023-03-01 March  2023 2022/2023   25-49    
#>  5    22 Kenya   VIA       Post-tr… 2022-08-01 Augu…  2022 2022/2023   <25      
#>  6   464 Kenya   HPV       Routine… 2024-02-01 Febr…  2024 2023/2024   25-49    
#>  7     1 Kenya   VIA       Post-tr… 2022-07-01 July   2022 2022/2023   <25      
#>  8   638 Kenya   Pap Smear Initial… 2023-08-01 Augu…  2023 2023/2024   25-49    
#>  9     3 Kenya   HPV       Routine… 2022-07-01 July   2022 2022/2023   <25      
#> 10   651 Kenya   Pap Smear Initial… 2023-07-01 July   2023 2023/2024   25-49    
#> # ℹ 679 more rows
#> # ℹ 1 more variable: source <fct>
```

### Aggregating Data

These functions are designed to efficiently download cancer screening
data at various aggregation levels (e.g., country, county). By
specifying the desired level, you can retrieve only the data you need,
reducing download times and optimizing transfer efficiency.

``` r
# Download cervical cancer screening data aggregated to country
cacx_screened <- get_cervical_screened('2021-07-01',
                                       end_date = '2021-12-31',
                                       level = 'country')
cacx_screened
#> # A tibble: 181 × 10
#>    value country element   category period     month  year fiscal_year age_group
#>  * <dbl> <chr>   <fct>     <fct>    <date>     <ord> <dbl> <fct>       <fct>    
#>  1     5 Kenya   HPV       Post-tr… 2021-07-01 July   2021 2021/2022   <25      
#>  2   106 Kenya   VIA       Routine… 2021-10-01 Octo…  2021 2021/2022   <25      
#>  3  2227 Kenya   VIA       <NA>     2021-11-01 Nove…  2021 2021/2022   50+      
#>  4    70 Kenya   Pap Smear Initial… 2021-10-01 Octo…  2021 2021/2022   25-49    
#>  5   872 Kenya   Pap Smear <NA>     2021-10-01 Octo…  2021 2021/2022   50+      
#>  6   455 Kenya   Pap Smear <NA>     2021-12-01 Dece…  2021 2021/2022   50+      
#>  7   109 Kenya   VIA       Routine… 2021-12-01 Dece…  2021 2021/2022   <25      
#>  8   167 Kenya   HPV       <NA>     2021-11-01 Nove…  2021 2021/2022   <25      
#>  9  1846 Kenya   VIA       <NA>     2021-12-01 Dece…  2021 2021/2022   50+      
#> 10   132 Kenya   HPV       <NA>     2021-10-01 Octo…  2021 2021/2022   <25      
#> # ℹ 171 more rows
#> # ℹ 1 more variable: source <fct>

# Download cervical cancer screening positives aggregated by county
cacx_positive <- get_cervical_positive('2021-07-01',
                                       end_date = '2021-12-31',
                                       level = 'county')
cacx_positive
#> # A tibble: 1,600 × 11
#>    value county      country element category period     month  year fiscal_year
#>  * <dbl> <chr>       <chr>   <fct>   <fct>    <date>     <ord> <dbl> <fct>      
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

# Download Breast mammogram screening aggregated by subcounty
breast_mammogram <- get_breast_mammogram('2021-07-01', 
                                         end_date = '2021-12-31',
                                         level = 'subcounty')
breast_mammogram
#> # A tibble: 21 × 12
#>    value subcounty       county country element age_group period     month  year
#>    <dbl> <chr>           <chr>  <chr>   <fct>   <fct>     <date>     <ord> <dbl>
#>  1    15 Starehe         Nairo… Kenya   BIRADS… 25-34     2021-07-01 July   2021
#>  2     1 Lurambi         Kakam… Kenya   BIRADS… 56-74     2021-09-01 Sept…  2021
#>  3     3 Mvita           Momba… Kenya   BIRADS… 40-55     2021-10-01 Octo…  2021
#>  4     1 Starehe         Nairo… Kenya   BIRADS… 56-74     2021-12-01 Dece…  2021
#>  5     1 Kirinyaga South Kirin… Kenya   BIRADS… 25-34     2021-12-01 Dece…  2021
#>  6     1 Starehe         Nairo… Kenya   BIRADS… 40-55     2021-09-01 Sept…  2021
#>  7     1 Laikipia East   Laiki… Kenya   BIRADS… 40-55     2021-11-01 Nove…  2021
#>  8     1 Kangundo        Macha… Kenya   BIRADS… 40-55     2021-11-01 Nove…  2021
#>  9     2 Mvita           Momba… Kenya   BIRADS… 40-55     2021-10-01 Octo…  2021
#> 10     1 Laikipia East   Laiki… Kenya   BIRADS… 35-39     2021-11-01 Nove…  2021
#> # ℹ 11 more rows
#> # ℹ 3 more variables: fiscal_year <fct>, source <chr>, category <fct>

# Download Fluid cytology data aggregated by facility
fluid_cytology <- get_lab_fluid_cytology('2021-07-01', 
                                         end_date = '2021-12-31',
                                         level = 'facility')
fluid_cytology
#> # A tibble: 2,433 × 12
#>    value facility ward  subcounty county element category period     month  year
#>    <dbl> <chr>    <chr> <chr>     <chr>  <fct>   <fct>    <date>     <ord> <dbl>
#>  1     0 Spicas … Chep… Cheptais  Bungo… CSF     Total E… 2021-12-01 Dece…  2021
#>  2     0 Miriri … Gach… Masaba N… Nyami… Pleura… Maligna… 2021-07-01 July   2021
#>  3     0 Mvono C… Wund… Wundanyi  Taita… Asciti… Total E… 2021-07-01 July   2021
#>  4     0 Machuru… Gesi… Masaba N… Nyami… CSF     Total E… 2021-10-01 Octo…  2021
#>  5     0 Maungu … Maru… Voi       Taita… CSF     Maligna… 2021-09-01 Sept…  2021
#>  6     0 Spicas … Chep… Cheptais  Bungo… CSF     Total E… 2021-10-01 Octo…  2021
#>  7     0 Elgon V… Race… Kesses    Uasin… CSF     Total E… 2021-10-01 Octo…  2021
#>  8     0 Embu Le… Kiri… Manyatta  Embu   Urine   Maligna… 2021-08-01 Augu…  2021
#>  9     0 Bunyore… Nort… Emuhaya   Vihiga Asciti… Maligna… 2021-10-01 Octo…  2021
#> 10     0 Derkale… Derk… Banissa   Mande… CSF     Maligna… 2021-12-01 Dece…  2021
#> # ℹ 2,423 more rows
#> # ℹ 2 more variables: fiscal_year <fct>, source <chr>
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
