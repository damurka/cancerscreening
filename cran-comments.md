## Resubmission
This is a resubmission. In this version `1.0.2` I have:

* Provided a link in the description to the Kenya Health Information System 
  webservices
  
* I have removed all references to `print` in my code. In the majority of the 
  code, I utilise `cli::cli_bulletize` that can be suppressed. I have also 
  provided mechanisms for suppressing outputs which include use of
  `options(cancerscreening_quiet = TRUE)` and functions like 
  `local_cancerscreening_quiet` and `with_cancerscreening` all which have been 
  documented in the `cancerscreening-configuration.Rd`.
  
* I have added return values to the `cancerscreening-configuration.Rd` and 
  `pipe.Rd`.

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
