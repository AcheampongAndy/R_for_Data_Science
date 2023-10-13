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

# Exercise 4

## assign clean corpus to object called corpus.clean
corpus.clean <- corpus %>% 
  str_to_lower() %>% 
  str_remove_all("[:punct:]") %>% 
  str_remove_all("[:digit:]") %>% 
  str_replace_all("\\s{2,}", " ") %>% 
  str_replace_all("\t|\n"," ") %>% 
  str_trim("both")


## create a table called corpus.words
## corpus.words holds two columns: word - word from the corpus, count - frequency
corpus.words <- corpus.clean %>% 
  str_c(sep = " ", collapse = " ") %>% 
  str_split(pattern = " ") %>% 
  unlist() %>% 
  tibble(word = .) %>% 
  group_by(word) %>% 
  summarise(count = n()) %>% 
  ungroup() %>% 
  arrange(desc(count))

set.seed(345)
## first sample words out of top 100 most frequent words
## keep only first 100 rows of sorted table corpus.words
## repeat sampling 10000 times

corpus.words.top100 <- corpus.words %>% 
  .[1:100,] %>% 
  mutate(prob = count / sum(count)) %>% 
  sample_n(., size = 10000, replace = T, weight = prob) %>% 
  select(word)

## when corpus.words is created convert column word to factor type
corpus.words.top100 <- corpus.words.top100 %>% 
  mutate(word = as.factor(word))

## extract unique factor levels using function from forcats package
corpus.words.top100 %>%
  pull(word) %>% 
  fct_unique()
  
## count each factor level occurrence using function from forcats package 
corpus.words.top100 %>%
  pull(word) %>% 
  fct_count() %>% 
  arrange(desc(n))