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
  mutate(rank = row_number(totalDistance)) %>% 
  group_by(rank >= 13) %>% 
  mutate(rank_type = case_when(`rank >= 13` == T ~ "Top_3",
            TRUE ~ "others")) %>% 
  ungroup() %>% 
  group_by(rank_type) %>% 
  summarise(totalDistanceFlown = sum(totalDistance)) %>% 
  ungroup() %>% 
  mutate(percentage = (totalDistanceFlown / sum(totalDistanceFlown) * 100))