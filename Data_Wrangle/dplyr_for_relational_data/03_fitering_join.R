# clear work space
rm(list = ls())

# load libraries
library(tidyverse)
library(nycflights13)

# data
airlines1 <- airlines %>% 
  filter(carrier %in% c("AA", "VX", "DL"))

# semi_join ()
semi_join(x = airlines1,
          y = flights,
          by = "carrier")

semi_join(x = flights,
          y = airlines1,
          by = "carrier")

# anti_join ()
anti_join(x = airlines1,
          y = flights,
          by = "carrier")

anti_join(x = flights,
          y = airlines1,
          by = "carrier")