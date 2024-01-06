
    Code chunks will not be evaluated, because:
    Set cred unsuccessful:

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
# install.packages("pak")
pak::pak('damurka/cancerscreening')
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
credential to download the data.

``` r
# Set the credentials using username and password
khis_cred(username = 'KHIS username', password = 'KHIS password')

# Set credentials using configuration path
khis_cred(config_path = 'path/to/secret.json')
```

After setting the credential you can invoke any function to download
data from the API

``` r
# Download the cervical cancer screening data for country
cacx_screened <- get_cervical_screened('2022-07-01')
head(cacx_screened)
```

### Metadata reuse

When you need data from more than one function it is efficient to
download the metadata and share among the functions as shown below:

``` r
# Download the organisation units
organisations <- get_organisation_units_metadata()
head(organisations)

# Download category options
categories <- get_category_options_metadata()
head(categories)

# Download data elements 
elements <- get_data_elements_metadata()
head(elements)

# Download cervical cancer screening data
cacx_screened <- get_cervical_screened('2021-07-01',
                                       end_date = '2021-12-31',
                                       level = 'county',
                                       elements = elements,
                                       categories = categories,
                                       organisations = organisations)
head(cacx_screened)

# Download cervical cancer screening positives
cacx_positive <- get_cervical_positive('2021-07-01',
                                       end_date = '2021-12-31',
                                       level = 'county',
                                       elements = elements,
                                       categories = categories,
                                       organisations = organisations)
head(cacx_positive)

# Download Breast mammogram screening
breast_mammogram <- get_breast_mammogram('2021-07-01', 
                                         end_date = '2021-12-31',
                                         level = 'county',
                                         elements = elements,
                                         categories = categories,
                                         organisations = organisations)
head(breast_mammogram)
```