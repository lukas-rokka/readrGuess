
<!-- README.md is generated from README.Rmd. Please edit that file -->
Tests different options for formatting the delimiter, decimal mark, grouping mark and column header. Chooses the combinations that creates a data frame that make most sense, based on the assumptions:

-   That data is rectangular, formatting that fail to read some of the columns are skipped
-   That formatting that gives more non-character columns is more likely to be right
-   That formatting that gives more total number of columns is more likely to be right
-   That if having columns header gives same result, then it more likely that headers are not present

For delimiters following are possible: tab (\\t), comma (,) and semicolon (;). As decimal mark: comma (,) and dot (.). As big number grouping mark: comma (,), dot (.) and space ( ) are tested. Column headers existence is also tested for, altogether 18 possible formatting combinations are tested.

Quick start
-----------

### Install

Dev version from GitHub.

``` r
devtools::install_github("lukas-rokka/readrGuess")
```

``` r
library(readr)
library(readrGuess)


# all formatting combinations that are currently tested
delim_cases()
#> # A tibble: 18 × 5
#>     name delim decimal_mark grouping_mark col_names
#>    <chr> <chr>        <chr>         <chr>     <lgl>
#> 1    csv     ,            .                    TRUE
#> 2   csv2     ;            ,             .      TRUE
#> 3   csv3     ;            ,                    TRUE
#> 4   csv4     ;            .             ,      TRUE
#> 5   csv5     ;            .                    TRUE
#> 6    tsv     \t            .             ,      TRUE
#> 7   tsv2     \t            .                    TRUE
#> 8   tsv3     \t            ,             .      TRUE
#> 9   tsv4     \t            ,                    TRUE
#> 10   csv     ,            .                   FALSE
#> 11  csv2     ;            ,             .     FALSE
#> 12  csv3     ;            ,                   FALSE
#> 13  csv4     ;            .             ,     FALSE
#> 14  csv5     ;            .                   FALSE
#> 15   tsv     \t            .             ,     FALSE
#> 16  tsv2     \t            .                   FALSE
#> 17  tsv3     \t            ,             .     FALSE
#> 18  tsv4     \t            ,                   FALSE
```

### Example

``` r
# Create a date frame and format it into a semicolon delimited string
test_str <- readr::format_delim(
  data.frame(a=runif(1000, -100, 100), b="a", c=1, d=TRUE), 
  ";")

# read the string and guess the right formatting
read_guess(test_str)
#> Delimiter: ';', decimal mark: '.', grouping mark: ',', column headers: TRUE
#> # A tibble: 1,000 × 4
#>            a     b     c     d
#>        <dbl> <chr> <dbl> <lgl>
#> 1   71.18648     a     1  TRUE
#> 2   18.36656     a     1  TRUE
#> 3  -11.74634     a     1  TRUE
#> 4  -97.23345     a     1  TRUE
#> 5  -89.95814     a     1  TRUE
#> 6  -25.24783     a     1  TRUE
#> 7  -44.13645     a     1  TRUE
#> 8  -20.31130     a     1  TRUE
#> 9  -84.77841     a     1  TRUE
#> 10  72.45058     a     1  TRUE
#> # ... with 990 more rows
```
