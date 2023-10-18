# clear environment
rm(list = ls())

# load libraries
library(lubridate)
library(dplyr)

# Create an interval
dt1 <- ymd("2021-12-30")
dt2 <- ymd("2021-12-31")
dt1; dt2

il <- interval(dt1, dt2)
it <- dt1 %--% dt2

# Extract boundaries
int_start(il)
int_end(il)

# Is time point within interval
today() %within% il

# Do intervals overlaps
int_overlaps(il, it)

# Create intervals from vector of dates
dates <- now() + days(1:365)
length(dates)
int_diff(dates)

# length of an interval and how to flip an interval
int_length(il)
int_flip(il)