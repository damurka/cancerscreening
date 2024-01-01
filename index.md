
# cancerscreening

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

### Load cancerscreening package

``` r
library("cancerscreening")
```

### Package conventions

- Most function begin with the prefix `get_` followed by the screening
  area `cervical` or `breast`. Auto-completion is your friend
- Goal is to allow the download of data associated with the data of
  interest, e.g. `get_cervical_screened`, `get_cervical_positive`, or
  `get_cervical_treated`
- cancerscreening is “pipe-friendly” and, infact rexports `%>%` but does
  not require its use.

### Quick demo

Before calling any function that makes an API call you need credentials
to [KHIS](https://hiskenya.org). You will be expected to set this
credential to download the data. The credentials are stored securely
with the operating system using the package `keyring`

``` r
# Set the credentials
khis_cred(username = 'KHIS username')
```

After setting the credential you can invoke any function to download
data from the API

``` r
# Download the cervical cancer screening data for country
data <- get_cervical_screened('2022-07-01')
```

### Metadata reuse

When you need data from more than one function it is efficient to
download the metadata and share among the functions as shown below:

``` r
organisations <- get_organisation_units_metadata()
categories <- get_category_options_metadata()
elements <- get_data_elements_metadata()

cacx_screened <- get_cervical_screened('2021-07-01',
                                       end_date = '2021-12-31',
                                       level = 'county',
                                       elements = elements,
                                       categories = categories,
                                       organisations = organisations)

cacx_positive <- get_cervical_positive('2021-07-01',
                                       end_date = '2021-12-31',
                                       level = 'county',
                                       elements = elements,
                                       categories = categories,
                                       organisations = organisations)

cacx_treated <- get_cervical_treated('2021-07-01',
                                     end_date = '2021-12-31',
                                       level = 'county',
                                       elements = elements,
                                       categories = categories,
                                       organisations = organisations)

breast_cbe <- get_breast_cbe('2021-07-01',
                             end_date = '2021-12-31',
                             level = 'county',
                             elements = elements,
                             categories = categories,
                             organisations = organisations)

breast_mammogram <- get_breast_mammogram('2021-07-01', 
                                         end_date = '2021-12-31',
                                         level = 'county',
                                         elements = elements,
                                         categories = categories,
                                         organisations = organisations)
```
