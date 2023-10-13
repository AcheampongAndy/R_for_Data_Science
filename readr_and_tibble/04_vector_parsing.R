# reset work space
rm(list = ls())

# load libraries
library(readr)
library(dplyr)

# vector parsing

# parse a character vector
parse_character(c("one", "two", 3))

# parse logical
parse_logical(c("T", "FALSE", "TRUE", "F"))

# problems with parsing
x <- parse_logical(c("T", "FALSE", "TRUE", "F"))
problems(x)

# parse integer
parse_integer(c("12", "19", "5"))

# parse factor
parse_factor(c("a", "a", "b"), levels = c("b", "a"))

# parse double
parse_double(c("12.6", "11.67"))

# different decimal mask
parse_double(c("12,6", "11,67"),
             locale = locale(decimal_mark = ","))

# parse number
parse_number(c("2", "$25", "1,000", "2.2", "10%"))

# specify grouping mark
parse_number("100,256.56",
             locale = locale(grouping_mark = ","))

# parse date
parse_date("2021-01-21")

# specify date format
parse_date("20210121", format = "%Y%m%d")
parse_date("21/01/21", format = "%y/%m/%d")

# parse time
parse_time("00:01")
parse_time("00:01 am")
parse_time("00:01:00")

# parse date time
parse_datetime("2021-01-21 00:01:00")
