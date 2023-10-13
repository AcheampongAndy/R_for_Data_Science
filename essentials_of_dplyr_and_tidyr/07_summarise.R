# clear work space
rm(list = ls())

# load libraries
library(dplyr)
library(ggplot2)

# Inspect data
df <- mpg

# summaries() - apply summary functions on our table and create summaries

## calculate the average of hwy
summarise(df, 
          `mean hwy` = mean(hwy))

## count table rows, count distinct car models
summarise(df,
          rows = n(),
          `nr models` = n_distinct(model))

## calculate min and max value for hwy and cty
summarise(df,
          `min hwy` = min(hwy),
          `min cty` = min(cty),
          `max hwy` = max(hwy),
          `max cty` = max(cty))
