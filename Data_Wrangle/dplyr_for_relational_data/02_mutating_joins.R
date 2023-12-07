# clear work space
rm(list = ls())
graphics.off()

# load libraries
library(tidyverse)
library(nycflights13)

# creating table 
table_x <- tribble(~key, ~val,
                   1, "a1",
                   2, "a2",
                   3, "a3")

table_y <- tribble(~key, ~val,
                   1, "b1",
                   2, "b2",
                   4, "b3")


# Inner join
inner_join(x = table_x,
           y = table_y,
           by = "key",
           suffix = c("_tab_x", "_tab_y"))

df <- flights %>% 
  inner_join(x = .,
             y = airlines,
             by = "carrier") %>% 
  rename(carrier_name = name)

df %>% 
  count(carrier_name) %>% 
  arrange(desc(n))

# Left join
left_join(x = table_x,
           y = table_y,
           by = "key")

## fix year column in planes table (rename it, to avoid confusion)
df.planes <- planes %>% 
  rename(year_plane = year)

## we will add data in a pipe (multiple left join)
df.all <- flights %>% 
  left_join(x = .,
            y = airlines,
            by = "carrier") %>% 
  rename(carrier_name = name) %>% 
  left_join(x = .,
            y = airports,
            by = c("dest" = "faa")) %>% 
  rename(dest_name = name) %>% 
  left_join(x = .,
            y = df.planes,
            by = "tailnum") %>% 
  left_join(x = .,
            y = weather, 
            by = c("year" = "year",
                   "month" = "month",
                   "hour" = "hour",
                   "day" = "day"))

# Right join
right_join(x = table_x,
          y = table_y,
          by = "key")

## flight counts
df.flight.counts <- flights %>% count(tailnum)

## bring flight counts to plane tables
df.planes <- df.flight.counts %>% 
  right_join(x = .,
             y = planes,
             by = "tailnum") %>% 
  rename(`number of flights` = n)

# full join
full_join(x = table_x,
           y = table_y,
           by = "key")

## select only relevant columns
df.dest <- flights %>% 
  select(carrier, dest)

## do full join
df.carrier_dest <- airlines %>% 
  full_join(x = .,
            y = df.dest,
            by = "carrier")

## do the check
df.carrier_dest %>% 
  filter(is.na(dest))

df.carrier_dest %>% 
  filter(is.na(carrier))