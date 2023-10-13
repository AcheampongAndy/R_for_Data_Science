# clear work space
rm(list = ls())

# load libraries
library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr)

# load string data set
load("./data/strings.RData")

# str_sub()

## replace first 3 letters of each fruit name with "FRU"
fruit.sub <- fruit
str_sub(fruit.sub, 1, 3) <- "FRU"
fruit.sub


# str_replace () - replace first matched pattern in a string

## replace first occurrence of letter "a" with "A" in each fruit
str_replace(fruit, "a", "A")


# str_replace () - replace all matched pattern in a string

## replace all occurrence of letter "a" with "A" in each fruit
str_replace_all(fruit, "a", "A")


# str_to_lower () - convert string to lower case
string.upper <- "THIS IS UPPER STRING"
string.upper
string.lower <- str_to_lower(string.upper)
string.lower

# str_to_upper () - convert string to upper case
str_to_upper(string.lower)

# str_to_title () - convert string to title case
str_to_title(string.lower)
