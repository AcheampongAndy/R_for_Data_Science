# clear work space
rm(list = ls())

# load libraries
library(dplyr)
library(tidyr)
library(ggplot2)

# inspect data
df <- mpg

# pivoting - convert table from wide to long format and (vice versal)

## lets create a simple table in long format
table.long <- data.frame(id = 1:6,
                         type = c("a", "b", "a", "c", "c", "a"),
                         count = c(20, 50, 45, 15, 12, 5))

# pivot_wider() - convert long table to wide table

## convert table to a wide format each "type" is written in its own column
table.wide <- pivot_wider(table.long,
                          names_from = type,
                          values_from = count)

# pivot_longer() - convert wide table to long table

## convert table back to long format
table.long1 <- pivot_longer(table.wide,
                            cols = c("a", "b", "c"),
                            names_to = "type",
                            values_to = "count",
                            values_drop_na = T)

# now lets pivot our car data set

## now filter rows where manufacturer is "jeep" or "land rover" or "hyundai"
## select model, trans, hwy
## calculate avg. hwy for each model and trans.
## this will be long table format
df.long <- df %>% 
  filter(manufacturer %in% c("jeep", "land rover", "hyundai")) %>% 
  select(model, trans, hwy) %>% 
  group_by(model, trans) %>% 
  summarise(`mean hwy` = mean(hwy)) %>% 
  ungroup()

## now convert long to wide format - where trans. is transformed into columns
df.wide <- df.long %>% 
  pivot_wider(names_from = trans,
              values_from = `mean hwy`)

## convert back to long format
df.long1a <- df.wide %>% 
  pivot_longer(cols = c(`auto(l4)`, `auto(l5)`, `auto(s6)`, `manual(m5)`, `manual(m6)`),
               names_to = "trans",
               values_to = "mean hwy",
               values_drop_na = T)
df.long1b <- df.wide %>% 
  pivot_longer(-model, #exclude the column model and use all remaining columns for the pivoting
               names_to = "trans",
               values_to = "mean hwy",
               #values_drop_na = T
               ) %>% 
  filter(!is.na(`mean hwy`))