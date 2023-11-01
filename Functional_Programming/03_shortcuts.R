# clear work space
rm(list = ls())
graphics.off()

# load libraries
library(tidyverse)
library(purrr)

# prepare data
df.mpg <- mpg %>% 
  select(hwy, displ, cyl) %>% 
  mutate(cyl = as.factor(cyl))

## fit model - map () no shortcuts
models <- df.mpg %>% 
  split(.$cyl) %>% 
  map(function(df) lm(formula = hwy ~ displ, data = df))

models 

## fit model - map () short
models <- df.mpg %>% 
  split(.$cyl) %>% 
  map(~lm(hwy ~ displ, data = .))

# extract R square for each model

## long syntax
models %>% 
  map(summary) %>% 
  map_dbl(~.$"r.squared")

## short syntax
models %>% 
  map(summary) %>% 
  map_dbl("r.squared")


# shortcut for extracting elements by position

## list
list <- list(list(1:3, 4:6, 7:9),
             list(10:12, 13:15, 16:18),
             list(19:21, 22:24, 25:27))

## extract third element form each sub-list and put the extracttion inside a list
list %>% map(3)