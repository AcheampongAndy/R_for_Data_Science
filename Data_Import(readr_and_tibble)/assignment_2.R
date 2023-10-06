# clear environment
rm(list = ls())

# load libraries
library(tibble)
library(dplyr)
library(readr)
library(data.table)


# Exercise 1

# create a tibble called continents, using data from the table shown on Figure 1.

continents <- tibble(
  `Date (date published)` = as.Date("2017-11-10"),
  Continent = c("Africa", "Antarctica", "Asia", "Europe", "North America", "South America", "Australia"),
  `Area (km2)` = c(30370000, 14000000, 44579000, 10180000, 2470900, 17840000, 8600000),
  `Percent total landmass` = c(20.4, 9.2, 29.5, 6.8, 16.5, 12.0, 5.9),
  Population = c(1287920000, 4499, 4545133000, 742648000, 587615000, 428240000, 41264000),
  `Percent total pop.` = c(16.9, 0.1, 59.5, 9.7, 7.7, 5.6, 0.5)
)


# After you have created a tibble use it to calculate given table summaries:

## total area
## total population
## sum of percentage - total landmass
## sum of percentage - total population

continents %>% 
  summarise(totalArea = sum(`Area (km2)`),
            totalPopulation = sum(Population),
            totalLandmass = sum(`Percent total landmass`),
            totalPopulationPerct = sum(`Percent total pop.`))


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
