<!-- badges: start -->
[![check-standard](https://github.com/damurka/cancerscreening/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/damurka/cancerscreening/actions/workflows/R-CMD-check.yaml)
[![test-coverage](https://github.com/damurka/cancerscreening/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/damurka/cancerscreening/actions/workflows/test-coverage.yaml)
[![pkgdown](https://github.com/damurka/cancerscreening/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/damurka/cancerscreening/actions/workflows/pkgdown.yaml)
<!-- badges: end -->

# cancerscreening
The goal of `cancerscreening` is to provide a easy way to download cancer screening data from the Kenya Health Information System (KHIS).

## Installation
You can install the released version of cancerscreening from [CRAN](https://cran.r-project.org/) with:
```{r}
install.packages("cancerscreening")
```
You can install the development version of from [Github](https://github.com) with:
```{r}
pak::pak('damurka/cancerscreening')
```
___Note: This package is not yet available on CRAN.___

## Basic Usage
Data that can be downloaded includes cervical cancer screening and breast cancer screening. Each of the has several modules

### Cervical cancer screening functions
- Get the target population for cervical cancer screening - `get_cervical_target_population` 
- Cervical cancer screening data using HPV, VIA or Pap smear - `get_cervical_screened` function
- Cervical cancer screening data for HIV positive - `get_cervical_hiv_screened` function
- Cervical cancer screening positive using HPV, VIA or Pap smear - `get_cervical_positive` function
- Cervical cancer precancerous lesion treatment using cryotherapy, thermoablation or LEEP - `get_cervical_treated` function

### Breast cancer screening function
- Get the target population for clinical breast examination - `get_breast_cbe_target_population`
- Get the target population for breast cancer screening with mammogram - `get_breast_mammogram_target_population` 
- Clinical breast examination performed - `get_breast_cbe` function
- Breast cancer screening using mammograms - `get_breast_mammogram` function

### Metadata functions
- Get the organisation units metadata - `get_organisation_units_metadata`
- Get the category options metadata - `get_category_options_metadata`
- Get the data elements metadata - `get_data_elements_metadata`
- Get additional data from the analytics table - `get_analytics`

The following is a basic example to show how to download cervical cancer screening data:

```{r}
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

When you need data from more than one function it is efficient to download the
metadata and share among the functions as shown below:

```{r}
khis_cred(username = 'KHIS username')

organisations <- get_organisation_units_metadata()
categories <- get_category_options_metadata()
elements <- get_data_elements_metadata()

cacx_screened <- get_cervical_screened('2021-07-01', 
                                       level = 'county',
                                       elements = elements,
                                       categories = categories,
                                       organisations = organisations)

cacx_positive <- get_cervical_positive('2021-07-01', 
                                       level = 'county',
                                       elements = elements,
                                       categories = categories,
                                       organisations = organisations)

cacx_treated <- get_cervical_treated('2021-07-01', 
                                       level = 'county',
                                       elements = elements,
                                       categories = categories,
                                       organisations = organisations)

breast_cbe <- get_breast_cbe('2021-07-01', 
                             level = 'county',
                             elements = elements,
                             categories = categories,
                             organisations = organisations)

breast_mammogram <- get_breast_mammogram('2021-07-01', 
                             level = 'county',
                             elements = elements,
                             categories = categories,
                             organisations = organisations)
```
