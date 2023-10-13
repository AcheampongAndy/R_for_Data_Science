# clear work space
rm(list = ls())

# load libraries
library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr)

# load strings dataset
load("./data/strings.RData")

# inspect all the strings that were imported
ls()

# str_detect() - for detecting a pattern
# similar to base R grepl()

## find a fruit containing letter "a" (anywhere)
fruit
ind <- str_detect(string = fruit, pattern = "a")
fruit[ind]

## the old way
grepl(pattern = "a", x = fruit)

## find a fruit not containing any letter "a"
fruit[str_detect(fruit, "a", negate = T)]

## inside tibble add flag if fruit contain letter "a"
fruit.df %>% 
  mutate(flag = case_when(str_detect(string = fruit, pattern = "a") ~ "contain 'a'",
                          TRUE ~ "does not cntain 'a'"))


# str_which() - detects a pattern and returns index position
# base R: grep()

ind <- str_which(string = fruit, pattern = "a")
fruit
fruit[ind]

# str_count() - count number of patterns matches in a string

## add count of letter "a" in each fruit (use a tibble)
fruit.df1 <- fruit.df %>% 
  mutate(`count a` = str_count(string = fruit, pattern = "a"))

## show me all fruits contain letters "a" 3 times
fruit.df1 %>% 
  filter(`count a` == 3)


# str_locate() / str_locate_all() - locate positions of pattern matches in a stirng
## locate position of first occurrence of letter "a"
str_locate(fruit, pattern = "a")

fruit.df2 <- str_locate(fruit, pattern = "a") %>% 
  as_tibble() %>% 
  mutate(fruit = fruit) %>% 
  select(fruit, start, end)

## locate position of all letters "a" in each fruit (list is return)
str_locate_all(fruit, pattern = "a")
