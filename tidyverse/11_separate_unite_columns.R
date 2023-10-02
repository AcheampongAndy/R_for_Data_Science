# clear work space
rm(list = ls())

# load libraries
library(dplyr)
library(tidyr)
library(stringr)

# separating and uniting columns

## lets create a table with date column (generate date for 1 year)
dates <- seq.Date(as.Date("2021-01-01"), to = as.Date("2021-12-31"), by = "day")
table <- data.frame(date = dates)


# separate() - split one column into multiple columns

## split date into year, month, and day of the month
## remove leading zeros where necessary 
## sort columns
table.sep <- table %>% 
  separate(data = .,
           col = date,
           into = c("year", "month", "dayOfMonth"),
           sep = "-") %>% 
  mutate(month = as.numeric(month),
         dayOfMonth = as.numeric(dayOfMonth)) %>% 
  arrange(year, month, dayOfMonth)

## or this also works as the above
table.sep.a <- table %>% 
  separate(data = .,
           col = date,
           into = c("year", "month", "dayOfMonth"),
           sep = "-") %>% 
  mutate_at(.tbl = .,
            .vars = c("month", "dayOfMonth"),
            .funs = as.numeric) %>% 
  arrange(year, month, dayOfMonth)


# unit() - combine multiple columns into one column

## we add leading zeros to month and dayOfMonth
## create one date column by merging
## -year, month, dayOfMonth
## sort columns
table.unite <- table.sep %>% 
  # add leading zeros
  mutate(month = str_pad(month, width = 2, side = "left", pad = "0"),
         dayOfMonth = str_pad(dayOfMonth, width = 2, side = "left", pad = "0")) %>% 
  unite(data = .,
       col = "date", year, month, dayOfMonth,
       sep = "-")

table.unite_a <- table.sep %>% 
  mutate_at(.tbl = .,
            .vars = c("month", "dayOfMonth"),
            .funs = str_pad, 2, "left", "0") %>% 
  unite(data = .,
        col = "date", year, month, dayOfMonth,
        sep = "-")