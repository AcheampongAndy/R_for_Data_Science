# clear environment
rm(list = ls())

# load libraries
library(tibble)
library(dplyr)
library(readr)
library(data.table)


# Exercise 2

# import .csv file called flights 02.csv

## assign imported object to R object named df2
## for importing use function from library readr
## inside function for importing, define column parsing
df2 <- read_csv(file = "./data_import/flights_02.csv",
                col_types = cols(
                  UniqueCarrier = col_factor(),
                  FlightNum = col_integer(),
                  Year = col_integer(),
                  Month = col_integer(),
                  DayofMonth = col_integer(),
                  Origin = col_factor(),
                  Dest = col_factor(),
                  Distance = col_double()
                ))

str(df2)
