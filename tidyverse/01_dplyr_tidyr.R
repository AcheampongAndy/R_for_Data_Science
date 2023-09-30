# tidyverse essentials:

rm(list = ls())
graphics.off()

# load libraries

library(tidyr)
library(dplyr)
library(ggplot2)

# Inspect data

help(mpg)
df <- mpg 

# Inspect the data types
str(df)

# check the number of row and columns
nrow(df); ncol(df)

# Manipulate variables (columns)

# select() columns selection

## extract: manufacturer, model, year
select(df, manufacturer, model, year)
df.car.info <- select(df, manufacturer, model, year)

## columns that begin with the letter: "m"
select(df, starts_with(match = "m"))

## columns that contains the letter: "r"
select(df, contains("r"))

## columns that end with the letter: "y"
select(df, ends_with("y"))

## select by column index (positions)
select(df, 1:3)
select(df, c(2, 5, 7))
select(df, (ncol(df) - 2):(ncol(df)))


# rename() - to rename columns

## rename "manufacturer" and "model"
df1 <- rename(df, 
              mnfc = manufacturer,
              mdl = model)

## cheking the column names
colnames(df1)

## select columns and rename columns in call
select(df,
       mnfc = manufacturer,
       mdl = model,
       everything())
