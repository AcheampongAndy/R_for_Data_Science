# clear environment
rm(list = ls())

# load libraries
library(tibble)
library(dplyr)
library(readr)
library(data.table)


# Exercise 4

# import .csv file called flights 04.csv, which is a larger flat file

## import file two times using readr library and data.table’s fread
## when importing with readr do column parsing at the point of import
## when importing with fread force all columns to be parsed as characters 
## (colClasses =”character”)
## compare execution times for each importing strategy
system.time(
  df.large.1 <- read_csv2(file = "./data_import/big_table_04.csv",
                          col_names = T,
                          col_types = cols(
                            word = col_character(),
                            logical = col_logical(),
                            integer = col_integer(),
                            double  = col_number(),
                            date = col_date())
  )
)

system.time(
  df.large.2 <- fread(file = "./data_import/big_table_04.csv",
                      sep = ";",
                      colClasses = "character"
  )
)