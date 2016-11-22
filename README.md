
<!-- README.md is generated from README.Rmd. Please edit that file -->
Runs through different options of formatting the delimiter, decimal mark and grouping mark and chooses the combinations that creates a data frame that make most sense. Based on the assumptions:

-   That data is rectangular, formatting that fail to read some of the columns are skipped
-   That formatting that gives more non-character columns is more likely to be right
-   That formatting that gives more total number of columns is more likely to be right

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
