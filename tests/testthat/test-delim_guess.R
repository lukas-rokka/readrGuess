context("test guess_delim()")


context("test delimited data frame")

# set up and testing data frame
test_delim <- tibble::tibble(
  chr1 = c("a", "b", "c"),
  chr2 = c("a", "b", "c"),
  lgl1 = c(TRUE, FALSE, TRUE),
  date1= lubridate::ymd(20160101, 20160102, 20160103),
  dttm1= lubridate::ymd_h(2016010112, 2016010213, 2016010314),
  int1 = as.integer(c(1, 2, 3)),
  dbl1 = c(1.1, 2.2, 3.3),
  int2 = as.integer(c(100, 20000, 3000000)),
  dbl2 = c(100.1, 20000.222, 3000000.3333),
  dbl3 = (rep(1e30, 3))
)

cases <- delim_cases() %>% dplyr::filter(delim!="")

for (i in 1:nrow(cases)) {
  # format the test as a string
  test_str <- readr::format_delim(
    test_delim %>%
      dplyr::mutate_if(is.numeric, format, trim=TRUE, big.mark=cases$grouping_mark[i], decimal.mark=cases$decimal_mark[i]),
    delim=cases$delim[i],
    col_names=cases$col_names[i])

  # run the guess_delim
  test_that(
    paste0(
      "testing ", cases$name[i],
      " delim = '", cases$delim[i],
      "' decimal_mark = '", cases$decimal_mark[i],
      "' grouping_mark = '", cases$grouping_mark[i],
      "' coloumn names = ", cases$col_names[i]
    ),
    {
      r <- guess_delim(test_str)
      expect_identical(cases$name[i], r$name[1])
      expect_identical(cases$col_names[i], r$col_names[1])
    }
  )
}


context("test whitespace/table data frame")

test_whitespace <-
"1   1   a    1      1G000G000
2   2D2 bb  22D0   1G000G000G000
3   3   c    3G333  1G000G000G000
"

cases <- delim_cases() %>% dplyr::filter(delim=="")

for (i in 1:nrow(cases)) {
  # format the test as a string
  test_str <- ifelse(cases$col_names[i], paste0("a   b   c    d      e\n", test_whitespace), test_whitespace)
  test_str <- gsub("D", cases$decimal_mark[i], test_str, fixed=TRUE)
  test_str <- gsub("G", cases$grouping_mark[i], test_str, fixed=TRUE)

  # run the guess_delim
  test_that(
    paste0(
      "testing ", cases$name[i],
      " delim = ''",
      " decimal_mark='", cases$decimal_mark[i],
      "' grouping_mark='", cases$grouping_mark[i],
      "' coloumn names=", cases$col_names[i]
    ),
    {
      r <- guess_delim(test_str)

      expect_identical(cases$name[i], r$name[1])
      expect_identical(cases$col_names[i], r$col_names[1])
    }
  )
}




