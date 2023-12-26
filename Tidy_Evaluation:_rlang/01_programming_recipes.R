# clear work space
rm(list = ls())

# load libraries
library(rlang)
library(tidyverse)

# programming with quoting function
data_median <- function(data, var){
  require(dplyr)
  
  var <- rlang::enquo(var)
  
  data %>% 
    summarise(median = median(!!var))
}

data_median(mpg, hwy)
data_median(diamonds, price)

# multiple arguments in quoting function
group_median <- function(data, var, ...){
  require(dplyr)
  
  var <- rlang::enquo(var)
  group_vars <- rlang::enquos(...)
  
  data %>% 
    group_by(!!!group_vars) %>% 
    summarise(median = median(!!var)) %>% 
    ungroup()
}

group_median(mpg, hwy, model)
group_median(mpg, hwy, manufacturer)
group_median(mpg, hwy)

# argument name of a quoting function
named_median <- function(data, var, name){
  require(dplyr)
  
  var <- rlang::enquo(var)
  name <- rlang::ensym(name)
  
  data %>% 
    summarise(!!name := median(!!var))
}

named_median(mpg, hwy, median_hwy)