#' Guesses proper delimiter, decimal mark and gruping mark
#'
#' @import readr
#' @import dplyr
#'
#' @export
guess_delim <- function(file, cases=delim_cases(), ...) {

  cases <- cases %>% mutate(n_cols=NA, n_nonchar_cols=NA)


  for (i in 1:nrow(cases)) {
    case <- cases[i, ]
    #cat("delim: ", case$delim, "\ndecimal_mark: ", case$decimal_mark, "\ngrouping_mark: ", case$grouping_mark, "\n\n")

    #df = read_delim2(file, case$delim, decimal_mark = case$decimal_mark, grouping_mark = case$grouping_mark, ...)
      #
     a <- tryCatch({
       df <- read_delim2(file, case$delim, decimal_mark = case$decimal_mark, grouping_mark = case$grouping_mark, ...)
       cases$n_cols[i] <- ncol(df)
       cases$n_nonchar_cols[i] <- sum(lapply(df, class) %>% unlist() == "character")
     }, warning = function(w) {
       # cases with warnings are not rectanguler (data.frames)
       # and therefore  considered as non-likely
     }, error = function(e) {
       stop(e)
     })
  }

  # choose cases with least non-character columns and most total number of columns
  cases %>% arrange(n_nonchar_cols, desc(n_cols)) #%>% slice(1:1)
}

#' Read flat file by guessing the formating
#'
#' @export
read_guess <- function(file, ...) {
  guess <- guess_delim(file, ...)
  print(guess)
  read_delim2(file, guess$delim[1], guess$decimal_mark[1], guess$grouping_mark[1], ...)
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

