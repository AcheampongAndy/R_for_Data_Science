# clear environment
rm(list = ls())
graphics.off()

# load libraries
library(lubridate)
library(hms)
library(nycflights13)
library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr)
library(forcats)

# basic objective
d <- as_date(18992)
d

t <- as_hms(120)
t

dt <- as_datetime(1640952000)
dt

# Parsing: string or number conversion...

## year, month, day, hours, minutes, seconds
ymd_hms("2021-12-31 12:00:00") %>% class()

## year, month, day, hours, minutes
ymd_hm("2021-12-31 12:00")

## year, month, day, hours
ymd_h("2021-12-31 12")

## day, month, year, hour, minute, second
dmy_hms("31 Dec 2021 12/15:00")

## third 
yq("2022: Q3")

hms(5, 10, 0)

# date_decimal() - parse date stored as decimal number
d <- seq(2021, 2022, 0.25)
d
date_decimal(d)

# fast_strptime () parse datetime
fast_strptime("2021-12-31 12:00:00", "%Y-%m-%d %H:%M:%S")

# parse_date_time () - easier parser
parse_date_time("2021-12-31 12:00:00", "ymd HMS")

# create date/time from individual components
flights

## create datetime and date columns using other component
flights %>% 
  select(year, month, day, hour, minute) %>% 
  mutate(datetime = make_datetime(year, month, day, hour, minute),
         date = make_date(year, month, day))

# Create date/time from an exiting object

## current time stamp and today's date
now()
today()