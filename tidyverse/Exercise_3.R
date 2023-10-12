# restore work space
rm(list = ls())

# load libraries
library(dplyr)
library(tidyr)
library(stringr)
library(hflights)
library(lubridate)
library(ggplot2)

# Inspect data
df <- hflights


# Exercise 3

## create date column 
## by uniting columns: year, month, day of month.
## when uniting columns do not lose source columns 
## (mutate each column - with slightly
## different name, before unite operation is executed)
## you will need to parse date column after unite operation
## also you should add leading zeros to 
## month and day of month column before date is created
df.date <- df %>% 
  mutate(Month1 = Month,
         DayofMonth1 = DayofMonth,
         Year1 = Year) %>% 
  # add leading zeros
  mutate_at(.vars = c("Month1", "DayofMonth1"),
            .funs = str_pad, 2, "left", "0") %>% 
  unite(col = "date", Year1, Month1, DayofMonth1,
        sep = "-") %>% 
  mutate(date = ymd(date),
         quarter = quarter(date),
         week = isoweek(date)) %>% 
  select(date, Year, Month, DayofMonth, quarter, week, everything())

## Is total number of flights increasing or decreasing quarterly?
df.date %>% 
  group_by(quarter) %>% 
  summarise(numOfFlight = n()) %>% 
  ungroup() %>% 
  mutate(deltaFlights = numOfFlight - lag(numOfFlight),
         quarter = as.factor(quarter)) %>% 
  ggplot(aes(x = quarter, y = deltaFlights)) +
  geom_col()


## Is total distance increasing or decreasing monthly?
df.date %>% 
  group_by(Month) %>% 
  summarise(totalDistance = sum(Distance)) %>% 
  ungroup() %>% 
  mutate(deltaDistace = totalDistance - lag(totalDistance),
         Month = as.factor(Month)) %>% 
  ggplot(aes(x = Month, y = deltaDistace)) +
  geom_col()