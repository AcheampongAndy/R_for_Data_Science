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

# Exercise 1

## How many rows and columns are in table hflights?
nrow(hflights); ncol(hflights)

## How many different carriers are listed in 
## the table (print a table with distinct carrier names)?
df %>% 
  group_by(UniqueCarrier) %>% 
  distinct() %>% 
  count() %>%
  arrange(n) %>% 
  ungroup()

## Which and how many airports were involved? 
## Consider both origin and destination airports!
df %>% 
  select(Origin, Dest) %>% 
  distinct() %>% 
  pivot_longer(cols = everything(),
               names_to = "Orig/Des",
               values_to = "airports") %>% 
  distinct(airports) %>% 
  arrange(airports)


## How many flights were cancelled?
df %>% 
  group_by(Cancelled) %>% 
  filter(Cancelled == 1) %>% 
  count() %>% 
  ungroup()


# Exercise 2

# First, produce a table where statistics for each carrier is shown:

## number of flights per carrier
## total distance flown in miles per carrier
## total actual elapsed time in hours per carrier
## total air time in hours per carrier
## mean distance per flight for each carrier
## mean actual elapsed time in hours per flight for each carrier
## mean air time in hours per flight for each carrier
carrier.stat <- df %>% 
  group_by(UniqueCarrier) %>% 
  summarise(numberOfFlights = n(),
            totalDistance = sum(Distance),
            totalTime = round(sum(ActualElapsedTime, na.rm = T) / 60, 2),
            totalAirTime = round(sum(AirTime, na.rm = T) / 60, 2),
            meanDistance = round(mean(Distance, na.rm = T), 2),
            meanActualTimeElapse = round(mean(ActualElapsedTime, na.rm = T), 2),
            meanAirTime = round(mean(AirTime, na.rm = T), 2))

## top 3 performing carriers VS total distance flown by remaining carriers.
carrier.stat %>% 
  select(UniqueCarrier, totalDistance) %>% 
  mutate(rank = row_number(totalDistance),
         totalDistanceSum = sum(totalDistance)) %>% 
  #arrange(desc(totalDistance)) %>% 
  group_by(rank >= 13) %>% 
  mutate(totalDistanceFlown = sum(totalDistance)) %>% 
  ungroup() %>% 
  group_by(totalDistanceFlown) %>% 
  mutate(percetOfTotalDist = (totalDistanceFlown / totalDistanceSum) * 100) %>% 
  select( -`rank >= 13`, -totalDistanceSum)


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


# Exercise 4

## for each carrier and month, calculate total number of flights
## then normalize total number of flights 
## (divide each value with maximum total number of
## flights, you must get values between 0 and 1!)
## so each row is represented with carrier, and each column 
## is represented with month,normalized total number 
## of flights are values in table cells
df.table <- df %>% 
  group_by(UniqueCarrier, Month) %>% 
  count() %>% 
  ungroup() %>% 
  group_by(Month) %>% 
  mutate(n = n / max(n)) %>% 
  ungroup() %>% 
  pivot_wider( names_from = Month, 
               values_from = n,
               values_fill = 0)


## visualising heat map
df %>% 
  group_by(UniqueCarrier, Month) %>% 
  count() %>% 
  ungroup() %>% 
  group_by(Month) %>% 
  mutate(n = n / max(n)) %>% 
  ungroup() %>% 
  mutate(Month = as.factor(Month)) %>% 
  ggplot(aes(x = UniqueCarrier,
             y = Month,
             fill = n)) +
  geom_tile() +
  scale_fill_viridis_c(option = "magma") +
  theme_minimal()