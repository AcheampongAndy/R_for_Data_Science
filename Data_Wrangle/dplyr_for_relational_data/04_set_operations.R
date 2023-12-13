# clear work space
rm(list = ls())

# load libraries
library(tidyverse)
library(nycflights13)

# create two simple tables
airlines1 <- airlines %>% slice(c(1, 3, 5, 7, 9))
airlines2 <- airlines %>% slice(c(2, 4, 5, 8, 9))

# bind_cols()
bind_cols(airlines1, airlines2)

# bind_rows ()
bind_rows(airlines1, airlines2)

# set operations

## intersect ()
intersect(airlines1, airlines2)

## setdiff ()
setdiff(airlines1, airlines2)

## union ()
union(airlines1, airlines2)