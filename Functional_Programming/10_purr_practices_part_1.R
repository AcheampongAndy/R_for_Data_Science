# clear workspace
rm(list = ls())
graphics.off()

# load libraries
library(tidyverse)

# count missing values 
mpg %>% 
  map_df(.x = .,
         .f = ~(data.frame(missing_values = sum(is.na(.x)),
                           distinct_values = n_distinct(.x),
                           class = class(.x))),
         .id = "variable")

# import multiple files into R

## import .csv files from a single directory
path = "./data/mpg_single_level"

df1 <- tibble(directory = path,
              files = list.files(path)) %>% 
  mutate(path = str_c(directory, files, sep = "/")) %>% 
  mutate(data = map(.x = path,
                    .f = function(path_){
                      read_csv(path_,
                               col_types = cols(.default = "c"))
                    })) %>% 
  pull(data) %>% 
  bind_rows()

## import multiple files and specify column types
df2 <- tibble(directory = path,
              files = list.files(path)) %>% 
  mutate(path = str_c(directory, files, sep = "/")) %>% 
  mutate(data = map(.x = path,
                    .f = function(path_){
                      read_csv(path_,
                               col_types = cols(
                                 manufacturer = col_character(),
                                 model = col_character(),
                                 displ = col_double(),
                                 year = col_integer(),
                                 cyl = col_integer(),
                                 trans = col_character(),     
                                 drv  = col_character(), 
                                 cty = col_double(),
                                 hwy = col_double(), 
                                 fl = col_character(),
                                 class = col_character()
                               ))
                    })) %>% 
  pull(data) %>% 
  bind_rows()

## import .csv files inside a level directory
path = "./data/mpg_double_level"

df3 <- tibble(directory = path,
              files = list.files(path, recursive = T)) %>% 
  mutate(path = str_c(directory, files, sep = "/")) %>% 
  mutate(data = map(.x = path,
                    .f = function(path_){
                      read_csv(path_,
                               col_types = cols(.default = "c"))
                    })) %>% 
  pull(data) %>% 
  bind_rows()