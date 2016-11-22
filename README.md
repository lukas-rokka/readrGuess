
<!-- README.md is generated from README.Rmd. Please edit that file -->
Tests different options for formatting the delimiter, decimal mark, grouping mark and column header. Chooses the combinations that creates a data frame that make most sense, based on the assumptions:

-   That data is rectangular, formatting that fail to read some of the columns are skipped
-   That formatting that gives more non-character columns is more likely to be right
-   That formatting that gives more total number of columns is more likely to be right
-   That if having columns header gives same result, then it more likely that headers are not present

Quick start
-----------

### Install

Dev version from GitHub.

``` r
devtools::install_github("lukas-rokka/readrGuess")
```

``` r
library("readrGuess")
```

### Example

``` r
read_guess(path_to_a_flat_file)
```
