# clearing environment
rm(list = ls())

# loading libraries
library(lubridate)
library(dplyr)

## rounding dates per month levels
d <- today()
d
floor_date(d, "month")
ceiling_date(d, "month")
round_date(d, "year")

# update components

## update each components by assigning new valuse
dt <- now()
year(dt) <- 2022 # updating year
month(dt) <- 07 # updating month
day(dt) <- 11 # updating day

## update () - update all components at once
update(dt, month = 12, day = 13, seconds = 10)