#' Guesses proper delimiter, decimal mark and gruping mark
#'
#' @import readr
#' @import dplyr
#'
#' @export
guess_delim <- function(file, cases=delim_cases()) {

  cases <- cases %>% mutate(n_cols=0, n_nonchar_cols=0)


  for (i in 1:nrow(cases)) {
    case <- cases[i, ]
    #cat("delim: ", case$delim, "\ndecimal_mark: ", case$decimal_mark, "\ngrouping_mark: ", case$grouping_mark, "\n\n")


    df = tryCatch({
      read_delim2(file, case$delim, decimal_mark = case$decimal_mark, grouping_mark = case$grouping_mark)
    }, warning = function(w) {
      tibble::tibble()
    }, error = function(e) {
      stop(e)
    })

    cases$n_cols[i] <- ncol(df)
    cases$n_nonchar_cols[i] <- sum(lapply(df, class) %>% unlist() == "character")
    #print(df)
  }

  # cases with warnings are not rectanguler (data.frames)
  # and therefore  considered as non-likely
  if (any(cases$n_nonchar_cols==0))
    cases[cases$n_nonchar_cols==0,]$n_nonchar_cols <- Inf

  # choose cases with least non-character columns and most total number of columns
  cases %>% arrange(n_nonchar_cols, desc(n_cols)) #%>% slice(1:1)
}

#' read_delim2
#'
#' @export
read_delim2 <- function(file, delim, decimal_mark, grouping_mark, ...) {
  suppressMessages(readr::read_delim(
    file,
    delim,
    locale = readr::locale(decimal_mark = decimal_mark, grouping_mark = grouping_mark),
    ...
  ))
}

#' Possible combinations formats
#'
#' @export
delim_cases <- function() {
  # All combinations to test for
  tibble::tribble(
    ~name,  ~delim, ~decimal_mark, ~grouping_mark,
    "csv",  ",",    ".",           " ",
    "csv2", ";",    ",",           ".",
    "csv3", ";",    ",",           " ",
    "csv4", ";",    ".",           ",",
    "csv5", ";",    ".",           " ",
    "tsv",  "\t",   ".",           ",",
    "tsv2", "\t",   ".",           " ",
    "tsv3", "\t",   ",",           ".",
    "tsv4", "\t",   ",",           " "
  )
}

