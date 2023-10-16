# clear environment
rm(list = ls())

# load libraries
library(lubridate)
library(hms)
library(nycflights13)
library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr)
library(forcats)

# Extract different component
dt <- now()
dt

## Extract year
year(dt)

## Extract month
month(dt)

## Extract day
day(dt)

## Extract hour
hour(dt)

## Extract minute
minute(dt)

## Extract seconds
second(dt)

# additional components

## week day
wday(dt)

## iso week
isoweek(dt)

## Extract week
week(dt)

## Quater day
qday(dt)
quarter(dt)

## semester
semester(dt)

## logicals
am(dt)
pm(dt)
leap_year(dt)

# store values of component into column
flights %>% 
  select(year, month, day, hour, minute) %>% 
  mutate(dateTime = make_datetime(year, month, day, hour, minute)) %>% 
  mutate(weekDay = wday(dateTime),
         week = week(dateTime)) %>% 
  arrange(desc(dateTime))