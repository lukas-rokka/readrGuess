
<!-- README.md is generated from README.Rmd. Please edit that file -->
Guesses the format of flat files by testing which combination of delimiter, decimal mark and grouping mark gives the most sensible data frame. Now defined as the set of combinations that result in most non-character columns as well maximizes the number of total columns.

Quick start
-----------

### Install

Dev version from GitHub.

``` r
devtools::install_github("lukas-rokka/readrGuess")
```

``` r
library("readrGuess")
#> Warning: replacing previous import 'dplyr::intersect' by
#> 'lubridate::intersect' when loading 'readrGuess'
#> Warning: replacing previous import 'dplyr::union' by 'lubridate::union'
#> when loading 'readrGuess'
#> Warning: replacing previous import 'dplyr::setdiff' by 'lubridate::setdiff'
#> when loading 'readrGuess'
```
