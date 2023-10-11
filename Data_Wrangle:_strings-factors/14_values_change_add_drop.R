# clear work space
rm(list = ls())

# load libraries
library(forcats)
library(ggplot2)
library(dplyr)
library(forcats)

# lets create factor variables
df <- mpg %>%
  mutate_at(.vars = c("manufacturer", "model", "trans", "class"),
            .funs = as_factor)

# fct_recode () 

## first lets pull levels and add country of origin
df %>% pull(manufacturer) %>% fct_count()

levels.country <- tibble(
  ~company,       ~country,
  
)