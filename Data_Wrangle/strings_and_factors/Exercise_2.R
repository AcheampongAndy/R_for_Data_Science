# clear work space
rm(list = ls())

# load libraries
library(ggplot2)
library(dplyr)
library(tidyr)
library(stringr)
library(forcats)
library(tibble)

# load data set
corpus <- readLines("./data/corpus.txt")

# Exercise 2

## use corpus and try to figure out which words usually come before comma ”,”
pattern <- "\\w+,"
corpus %>% str_subset(pattern) %>% str_view_all(pattern)

count <- corpus %>% 
  str_extract(pattern) %>% # extract pattern
  str_to_lower(.) %>%  # convert to lower case
  str_remove(",") %>% 
  tibble(pattern = .) %>% 
  count(pattern) %>% 
  arrange(desc(n))

## if you consider first 5 letters at the beginning of each line, 
## what are the top patterns that lines start with?
corpus %>% 
  str_to_lower(.) %>% 
  str_sub(1, 5) %>% 
  tibble(pattern = .) %>%
  count(pattern) %>% 
  arrange(desc(n))

##  find words where: a vowel is followed by a vowel
vowels <- "a|e|i|o|u"
pattern <- paste0("(", vowels, ")", "(?=","(", vowels, ")",")")
corpus %>% str_to_lower(.) %>% str_subset(pattern) %>% str_view_all(pattern) 

## find words where: a vowel is followed by two or more vowels
vowels <- "a|e|i|o|u"
pattern <- paste0("(", vowels, ")", "(?=","(", vowels, ")","{2,}",")")
corpus %>% str_to_lower(.) %>% str_subset(pattern) %>% str_view_all(pattern)

## find words where: 2 vowels are not followed by a vowel
vowels <- "a|e|i|o|u"
pattern <- paste0("(", vowels, ")","{2}", "(?!","(", vowels, ")",")")
corpus %>% str_to_lower(.) %>% str_subset(pattern) %>% str_view_all(pattern)

## check occurrence of words ”the”, ”be”, ”to”, ”of”, ”and”
corpus.low <- corpus %>% str_to_lower()

# a function to count the number of occurrence of word
fcount <- function(word){
  return(corpus.low %>% str_count(., word) %>% sum(.))
}

most_common_word <- tibble(
  words = c("the", "be", "to", "of", "and"),
  count = c(fcount("the"), fcount("be"), fcount("to"), fcount("of"), fcount("and"))
)
# or
most_common_word <- tribble(
  ~words, ~count,
  "the",   fcount("the"), 
  "be",    fcount("be"),
  "to",    fcount("to"),
  "of",    fcount("of"),
  "and",   fcount("and"),
) %>% arrange(desc(count))

# top 3 most common words check
## number of lines only one word is present
## number of lines 2 words are present
## also add percentage % of lines for each given scenario!
tibble(text = corpus.low) %>% 
  mutate(the = str_detect(text, "the"),
         to = str_detect(text, "to"),
         and = str_detect(text, "and")) %>% 
  mutate(`how many lines present` = the + to + and) %>% 
  group_by(`how many lines present`, the, to, and) %>% 
  summarise(`num of lines` = n()) %>% 
  ungroup() %>% 
  mutate(percentage = (`num of lines` / sum(`num of lines`)) * 100) %>% 
  arrange(desc(`num of lines`))