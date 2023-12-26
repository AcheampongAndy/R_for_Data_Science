# clear work space
rm(list = ls())

# load libraries
library(tidyverse)
library(rlang)

# summary function
my_summary <- function(data, var, ...){
  require(dplyr)
  require(rlang)
  
  var <- rlang::enquo(var)
  group_var <- rlang::enquos(...)
  
  data %>% 
    group_by(!!!group_var) %>% 
    summarise(min = min(!!var),
              max = max(!!var),
              median = median(!!var),
              mean = mean(!!var),
              sd = sd(!!var),
              range = max - min) %>% 
    ungroup()
}

my_summary(mpg, hwy, manufacturer)

count_freq <- function(df, ...){
  require(dplyr)
  require(rlang)
  
  group_vars <- rlang::enquos(...)
  
  df %>% 
    group_by(!!!group_vars) %>% 
    summarise(count = n())
}

count_freq(mpg)
count_freq(mpg, manufacturer)


# moving average

df.infections <- tibble(date = seq.Date(from = as.Date('2021-01-01'),
                                        to   = as.Date('2021-01-31'),
                                        by  = 'day'),
                        inf = c(100, 120, 60, 20,
                                180, 160, 150, 140, 180, 100, 50,
                                190, 170, 150, 180, 200, 120, 70,
                                180, 180, 200, 200, 220, 150, 100,
                                250, 300, 280, 290, 350, 200))
moving_average <- function(data, var){
  require(rlang)
  require(dplyr)
  
  var <- enquo(var)
  
  data %>% 
    # add lag values from t-1 up to t-6
    mutate(x1 = lag(!!var, 1),
           x2 = lag(!!var, 2),
           x3 = lag(!!var, 3),
           x4 = lag(!!var, 4),
           x5 = lag(!!var, 5),
           x6 = lag(!!var, 6)) %>% 
    # replace NA with 0
    mutate_at(., .vars = paste0('x', 1:6), .funs = replace_na, 0) %>% 
    # calculate moving average
    mutate(`3 day avg` = (!!var + x1 + x2) / 3,
           `7 day avg` = (!!var + x1 + x2 + x3 + x4 + x5 + x6) / 7)
}
df.infections1 <- moving_average(df.infections, inf)

# visualization
df.infections1 %>% 
  filter(date > '2021-01-05') %>% 
  select(date, inf, `3 day avg`, `7 day avg`) %>% 
  pivot_longer(cols = c('inf', '3 day avg', '7 day avg'),
               names_to = 'variable',
               values_to = 'value') %>% 
  ggplot(aes(x = date, 
             y = value,
             color = variable)) +
  geom_line(size = 2)