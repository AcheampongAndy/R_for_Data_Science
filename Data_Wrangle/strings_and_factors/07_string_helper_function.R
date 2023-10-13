# clear work space
rm(list = ls())

# load libraries
library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr)
library(htmlwidgets)

# load string data set
load("./data/strings.RData")

# str_order ()

## let's first shuffle fruits (to get random order)
set.seed(123)
fruit.shuf <- sample(fruit, length(fruit), F)
fruit.shuf[str_order(fruit.shuf)]

## of use str_sort() 
str_sort(fruit.shuf)

## sorting numbers stored as string
number.s <- sample(1:250, 20, F)
number.s <- as.character(number.s)

str_sort(number.s)
str_sort(number.s, numeric = T)


# str_view() and str_view_all () - useful HTML rendering function

## view first match
str_view(string = fruit, pattern = "a")
str_view(string = fruit, pattern = "^a", match = T) # show only fruit starting with letter "a"

## view all matches for 
str_view_all(fruit, "a", T)
