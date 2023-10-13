# clear work space
rm(list = ls())

# load libraries
library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr)

# load string data set
load("./data/strings.RData")


# str_sub() - Extract part of s string
# similar base R: substr()

#   Extract first 3 letters of a fruit
str_sub(string = fruit, start = 1, end = 3)
substr(x = fruit, start = 1, stop = 3)

#   Extract first letter of common word and count word frequency by first word letter
words.df %>% 
  mutate(`first letter` = str_sub(word, 1, 1)) %>% # extract first letter
  count(`first letter`) %>% # count frequencies
  arrange(desc(n)) # sort from high to low frequency

#   Extract middle part of the word
str_sub(fruit, start = 3, end = 5) # from 3rd to 5th letter

#   Extract last letter / last 3 letters (use negative counters - for counting backward)
str_sub(fruit, start = -1, end = -1) # last letter
str_sub(fruit, start = -3, end = -1) # last 3 letters


# str_subset() - Return only strings that match pattern

#   Return fruit containing letter "c"
str_subset(string = fruit, pattern = "c")

#   Return fruit starting with letter "c"
str_subset(string = fruit, pattern = "^c")


# str_extract() / str_extract_all() - Return first or every pattern match

#   Return fruit containing "a" first occurence
str_extract(string = fruit, pattern = "a")  # vector is returned

#   Return fruit containing "a" all occurences
str_extract_all(string = fruit, pattern = "a") #  list is returned


# str_match() / str_match_all() - Return first or every pattern match (as a matrx)

#   Return fruit containing "a" first occurence
str_match(string = fruit, pattern = "a")  # matrix is returned

#   Return fruit containing "a" all occurences
str_match_all(string = fruit, pattern = "a") #  matrix inside list is returned