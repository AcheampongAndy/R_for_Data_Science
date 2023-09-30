# reset work space
rm(list = ls())

# load libraries
library(dplyr)
library(ggplot2)

# Inspect data
df <- mpg

# distinct() - unique rows

## create small table
df.example <- data.frame(id = 1:3,
                         name = c("Alice", "Dean", "Bod"))

## create duplicate observation
df.example <- bind_rows(df.example, slice(df.example, c(1, 3)))

## sort the data by id (ascending)
df.example <- arrange(df.example, id)

## remove duplicate rows
distinct(df.example)

# back to mpg example - lets create tables with duplicate
df.dupl <- select(df, manufacturer, model)

## keep only distinct rows
df.nodupl <- distinct(df.dupl)
