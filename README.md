
<!-- README.md is generated from README.Rmd. Please edit that file -->
Guesses the formatting of tabular/flat files by testing different options for formatting the delimiter, decimal mark, grouping mark and column header. Chooses the combinations that creates a data frame that make most sense, based on the assumptions:

-   That data is rectangular, delimiters that fails to read some of the columns are skipped
-   That formatting that gives more total number of columns is more likely to be right
-   That formatting that gives more non-character columns is more likely to be right
-   That if having columns header doesn't do any difference, then it more likely that headers are not present

For delimiters following are possible: tab (\\t), comma (,), semicolon (;) and whitespace/fixed width. As decimal mark: comma (,) and dot (.). As big number grouping mark: comma (,), dot (.) and space ( ) are tested. Column headers existence is also tested for, altogether 22 possible formatting combinations are tested.

This Shiny app <https://rokka.shinyapps.io/smartep> demonstrates how this package (together with <https://github.com/ijlyttle/shinypod>) can be used to create an tabular/flat file reader that you can throw almost any file at - and it will in most cases guess the right formatting for you.

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
```

### Example

``` r

# Print all formatting combinations that are currently tested
delim_cases()
#> # A tibble: 22 × 5
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
#> 10   wsp                  .             ,      TRUE
#> # ... with 12 more rows

# Create a date frame and format it into a semicolon delimited string
test_str <- readr::format_delim(
  data.frame(a=runif(1000, -100, 100), b="a", c=1, d=TRUE), 
  ";")

# Read the string and guess the right formatting
read_guess(test_str)
#> Delimiter: ';', decimal mark: '.', grouping mark: ',', column headers: TRUE
#> # A tibble: 1,000 × 4
#>              a     b     c     d
#>          <dbl> <chr> <dbl> <lgl>
#> 1    0.5710977     a     1  TRUE
#> 2  -68.7795925     a     1  TRUE
#> 3  -51.5204403     a     1  TRUE
#> 4   38.9085193     a     1  TRUE
#> 5   82.8925392     a     1  TRUE
#> 6   68.2881441     a     1  TRUE
#> 7   69.1850611     a     1  TRUE
#> 8  -71.8340796     a     1  TRUE
#> 9  -42.3778389     a     1  TRUE
#> 10  92.0550250     a     1  TRUE
#> # ... with 990 more rows
```
