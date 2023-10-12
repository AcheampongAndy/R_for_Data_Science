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

# Exercise 1

## check number of lines in corpus
length(corpus)

## check number of characters
str_length(corpus) %>% sum()

## print first and last six lines
head(corpus)
tail(corpus)

## count how many lines include at least one punctuation
corpus %>% str_detect(., "[:punct:]") %>% sum()

## show first 20 lines without any punctuation
corpus %>% str_subset(., "[:punct:]", negate = T) %>% head(20)

## count how many lines include at least one number / digit
corpus %>% str_detect(., "[:digit:]") %>% sum()

## inspect first 10 lines with digit present
corpus %>% str_subset(., "[:digit:]") %>% head(10) %>% str_view_all("[:digit:]")

## find string patterns that resemble phone numbers
pattern <- "\\d\\d\\d-\\d\\d\\d\\d" # or
pattern <- "\\d{3}-\\d{4}"
corpus %>% str_subset(pattern) %>% str_view_all(pattern)

## find string patterns that resemble dollar signs ”$” (escaping needed)
pattern <- "\\$"
corpus %>% str_subset(pattern) %>% str_view_all(pattern)

## how many lines starts with word ”The”?
pattern <- "^The"
corpus %>% str_subset(pattern) %>% str_view_all(pattern)