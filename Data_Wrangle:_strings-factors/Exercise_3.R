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


# Exercise 3

## assign clean corpus to object called corpus.clean
corpus.clean <- corpus %>% 
  str_to_lower() %>% 
  str_remove_all("[:punct:]") %>% 
  str_remove_all("[:digit:]") %>% 
  str_replace_all("\\s{2,}", " ") %>% 
  str_replace_all("\t|\n"," ") %>% 
  str_trim("both")

corpus.clean %>% head()

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
  
## add column % coverage, which tells us the percentage of text
corpus.words <- corpus.words %>% 
  mutate(coverage = (count / sum(count)) * 100)

## how many different words were found in corpus?
corpus.words %>% nrow()

## how much text is covered with the most frequent word?
corpus.words %>% slice(1)

## how much text is covered with the top 10 most frequent words?
corpus.words %>% head(10) %>% pull(count) %>% sum()

## how many words we need to cover 50%, or 70%, or 90% of corpus?
corpus.words <- corpus.words %>% 
  mutate(`commulative of coverage` = cumsum(coverage))

corpus.words %>% 
  filter(`commulative of coverage` <= 50) %>% 
  nrow()

corpus.words %>% 
  filter(`commulative of coverage` <= 70) %>% 
  nrow()

corpus.words %>% 
  filter(`commulative of coverage` <= 90) %>% 
  nrow()