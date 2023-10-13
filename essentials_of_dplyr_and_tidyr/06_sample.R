# clear work space
rm(list = ls())

# load libraries
library(dplyr)
library(ggplot2)

# Inspect the data
df <- mpg

# sample rows

# sample_n() - randomly select n different rows
set.seed(567)

## 10 randomly selected rows without replacement
sample_n(df, size = 10, replace = FALSE)

## 10 randomly selected rows with replacement
sample_n(df, size = 10, replace = TRUE)

# sample_frac() - randomly select a fraction of rows

## 10% of table rows randomly selected
sample_frac(df, size = 0.1, replace = FALSE)
