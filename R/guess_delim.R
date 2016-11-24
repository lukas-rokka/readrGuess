#' Guesses proper delimiter, decimal mark and gruping mark
#'
#' @import readr
#' @import dplyr
#' @import tibble
#'
#' @export
guess_delim <- function(file, locale=NULL, ...) {

  cases <- delim_cases() %>% mutate(n_cols=NA, n_nonchar_cols=NA)

  if(is.null(locale)) locale <- readr::locale()

  for (i in 1:nrow(cases)) {
    case <- cases[i, ]
    #cat("delim: ", case$delim, "\ndecimal_mark: ", case$decimal_mark, "\ngrouping_mark: ", case$grouping_mark, "\n\n")

    a <- tryCatch({
      df <- read_delim2(
        file,
        delim = case$delim,
        decimal_mark = case$decimal_mark,
        grouping_mark = case$grouping_mark,
        col_names = case$col_names,
        locale = locale,
        ...
      )
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
  cases <- cases %>% arrange(n_nonchar_cols, desc(n_cols), col_names) #%>% slice(1:1)

}

#' Read flat file by guessing the formating
#'
#' @export
read_guess <- function(file, locale=NULL, ...) {
  guess <- guess_delim(file, locale, ...) %>% slice(1)
  message("Delimiter: '", guess$delim,
          "', decimal mark: '", guess$decimal_mark,
          "', grouping mark: '", guess$grouping_mark,
          "', column headers: ", guess$col_names)

  read_delim2(
    file,
    delim = guess$delim,
    decimal_mark = guess$decimal_mark,
    grouping_mark = guess$grouping_mark,
    col_names = guess$col_names,
    locale = locale,
    ...
  )
}

#' read_delim2
#'
#' @export
read_delim2 <- function(file, delim=",", decimal_mark=".", grouping_mark=" ", col_names=TRUE, locale=NULL, ...) {
  if(is.null(locale)) locale <- readr::locale()
  locale$decimal_mark  <- decimal_mark
  locale$grouping_mark <- grouping_mark
  suppressMessages(readr::read_delim(file, delim, col_names=col_names, locale = locale, ...))
}

#' Possible combinations of formatting
#'
#' @export
delim_cases <- function() {
  # All combinations to test for
  df <- tibble::tribble(
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
  df %>% mutate(col_names=TRUE) %>%
    bind_rows(df %>% mutate(col_names=FALSE))

}

