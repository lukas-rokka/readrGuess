context("test guess_delim()")

# set up and testing data frame
test_df <- tibble::tibble(
  chr1 = c("a", "b", "c"),
  lgl1 = c(TRUE, FALSE, TRUE),
  date1= lubridate::ymd(20160101, 20160102, 20160103),
  dttm1= lubridate::ymd_h(2016010112, 2016010213, 2016010314),
  int1 = as.integer(c(1, 2, 3)),
  dbl1 = c(1.1, 2.2, 3.3),
  int2 = as.integer(c(100, 20000, 3000000)),
  dbl2 = c(100.1, 20000.222, 3000000.3333),
  dbl3 = (rep(1e30, 3))
)


# read caeses to test
for(col_names2 in c(TRUE, FALSE)) {
  context(paste0("test with data frame that has col_names = ", col_names2))
  cases <- delim_cases() %>% filter(col_names==col_names2)

  for (i in 1:nrow(cases)) {
    # format the test as a string
    test_str <- readr::format_delim(
      test_df %>%
        dplyr::mutate_if(is.numeric, format, trim=TRUE, big.mark=cases$grouping_mark[i], decimal.mark=cases$decimal_mark[i]),
      delim=cases$delim[i],
      col_names=col_names2)

    # run the guess_delim
    test_that(
      paste0(
        "testing ", cases$name[i],
        " delim = '", cases$delim[i],
        "' decimal_mark = '", cases$decimal_mark[i],
        "' grouping_mark = '", cases$grouping_mark[i], "'"
      ),
      {
        r <- guess_delim(test_str)
        expect_identical(cases$name[i], r$name[1])
        expect_identical(cases$col_names[i], r$col_names[1])
      }
    )
  }
}
