# cancerscreening
The goal of `cancerscreening` is to provide a easy way to download cancer screening data from the Kenya Health Information System (KHIS).

## Installation
You can install the development version of rKenyaCensus from GitHub with:
```{r}
#install.package('devtools')
devtools::install_github('damurka/cancerscreening')
```
___Note: This package is not yet available on CRAN.___

## Example
Data that can be downloaded includes cervical cancer screening and breast cancer screening. Each of the has several modules

### Cervical cancer screening functions
- Get the target population for cervical cancer screening - `cervical_target_population` 
- Cervical cancer screening data using HPV, VIA or Pap smear - `get_cervical_screened` function
- Cervical cancer screening data for HIV positive - `get_cervical_hiv_screened` function
- Cervical cancer screening positive using HPV, VIA or Pap smear - `get_cervical_positive` function
- Cervical cancer precancerous lesion treatment using cryotherapy, thermoablation or LEEP - `get_cervical_treated` function

### Breast cancer screening function
- Get the target population for clinical breast examination - `cbe_target_population`
- Get the target population for breast cancer screening with mammogram - `mammogram_target_population` 
- Clinical breast examination performed - `get_cbe_conducted` function
- Breast cancer screening using mammograms - `get_mammogram_screened` function

The following is a basic example to show how to download cervical cancer screening data:

```{r}
# Load the package
library(cancerscreening)

# Get credential to make API calls to KHIS
loginToKHIS(username = 'KHIS Username')

# Get cervical cancer screening target population
target <- cervical_target_population(year = 2023)

# Download the cervical cancer screening data
data <- get_cervical_screened('2022-07-01')

# To learn more about the function, run the following command
?get_cervical_screened
```
