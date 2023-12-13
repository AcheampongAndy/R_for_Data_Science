# clear work space
rm(list = ls())
graphics.off()

# load libraries
library(tidyverse)
library(nycflights13)

# create a table called distance_per_date
distance_per_date <- flights %>% 
  # including carrier name
  left_join(x = .,
            y = airlines %>% rename(carrier_name = name)) %>%
  # creating the date column
  mutate(month1 = str_pad(month, 2, "left", pad = "0"),
         day1 = str_pad(day, 2, "left", pad = "0"),
         year1 = year) %>% 
  unite(date, year1, month1, day1, sep = "-") %>% 
  mutate(date = ymd(date)) %>% 
  # calculate total distance flown for each carrier per date
  group_by(carrier_name, date) %>% 
  summarise(`distance flown` = sum(distance)) %>% 
  ungroup()

# create a table called date_span
dates_span <- tibble(date = seq.Date(min(distance_per_date$date),
                                     max(distance_per_date$date),
                                     1))