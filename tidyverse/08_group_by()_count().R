# clear work space
rm(list = ls())

# load libraries
library(dplyr)
library(ggplot2)

# Inspect data
df <- mpg

# group_by() - group cases using one or more grouping variables

## group by manufacturer
df 
group_by(df, manufacturer)


# combine summarise() and group_by() - summary statistics for group data

## count num of cars per each manufacturer
summarise(group_by(df, manufacturer),
          cars = n())

## calculate min / max for hwy and cty group by model
df.group.model <- group_by(df, model)

summarise(df.group.model, 
          `min hwy` = min(hwy),
          `min cty` = min(cty),
          `max hwy` = max(hwy),
          `max cty` = max(cty))


# count() - count the rows for grouped variables

## count number of table rows
count(df)

## count number of rows/cars per model
count(df, model)