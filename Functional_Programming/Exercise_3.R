# clear work space
rm(list = ls())
graphics.off()

# load libraries
library(tidyverse)

# import
gapminder <- tibble(directory = "./data/gapminder/",
                    files = list.files("./data/gapminder")) %>% 
  mutate(path = str_c(directory, files)) %>% 
  mutate(data = map(.x = path,
                    .f = function(path_){
                      read_csv(path_,
                               col_types = cols(.default = "c"))
                    })) %>% 
  pull(data) %>% 
  bind_rows() %>% 
  mutate_at(.vars = c("country", "continent"), .funs = as.factor) %>% 
  mutate_at(.vars = c("year", "lifeExp", "pop", "gdpPercap"), .funs = as.numeric)