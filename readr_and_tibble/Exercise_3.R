# clear environment
rm(list = ls())

# load libraries
library(tibble)
library(dplyr)
library(readr)
library(data.table)


# Exercise 3

# import .csv file called flights 03.csv.

## assign imported object to R object named df3
## for importing use function from library readr
## function for import should include some additional import strategies 
## (compared to pre-vious example!)

df3 <- read_delim(file = "./data_import/flights_03.csv",
                  delim = "|",
                  col_names = F,
                  comment = "#",
                  skip = 12)

# naming the columns and parsing them
df3 <- df3 %>% 
  rename( UniqueCarrier = X1,
          FlightNum = X2,
          Date = X3,
          Origin = X4,
          Dest = X5,
          Distance = X6) %>% 
  mutate_at(.vars = c("UniqueCarrier", "Origin", "Dest"),
            .funs = as.factor) %>% 
  mutate_at(.vars = "Date", .funs = as.Date) %>% 
  mutate_at(.vars = "Distance", .funs = as.double) %>% 
  mutate_at(.vars = "FlightNum", .funs = as.integer)

str(df3)
