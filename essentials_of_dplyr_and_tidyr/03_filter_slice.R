# reset work space

rm(list = ls())

# load libraries
library(dplyr)
library(ggplot2)

# Inspect data
df <- mpg

# Manipulate cases (rows)

# filter rows by condition

## where manufacturer = "audi"
filter(df, manufacturer == "audi")

## where manufacturer is "audi" and year is 1999
filter(df, manufacturer == "audi" & year == 1999)

## where manufacturer is "audi" or "dodge"
filter(df, manufacturer == "audi" | manufacturer == "dodge")

## hwy is greater or equal to 30
filter(df, hwy >= 30)

## where yeaer is not equal to 1999
filter(df, year != 1999)


# slice () - extract rows by position

## extract the first five rows
slice(df, 1:5)

## extract rows from rows 20th up to rows 30th
slice(df, 20:30)

## extract last 10 rows
slice(df, (nrow(df) - 9):(nrow(df)))
