# clear work space
rm(list = ls())

# load libraries
library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr)
library(htmlwidgets)

# load string data set
load("./data/strings.RData")

# Look arounds

## find a word where letter "w" is followed by letter "a"
str_subset(words, "w(?=a)")
str_view_all(words, "w(?=a)", T)

## find a word where letter "w" is not followed by letter "a"
str_subset(words, "w(?!a)")
str_view_all(words, "w(?!a)", T)

## find a word where letter "a" is preceded by letter "w"
str_subset(words, "(?<=w)a")
str_view_all(words, "(?<=w)a", T)

## find a word where letter "a" is not preceded by letter "w"
str_subset(words, "(?<!w)a")
str_view_all(words, "(?<!w)a", T)


# Quantifiers

strings <- " .A.AA.AAA.AAAA"


## zero or one "A"
str_view_all(strings, "A?", T)

## zero or more "A"
str_view_all(strings, "A*", T)

## one or more "A"
str_view_all(strings, "A+", T)

## exactly two times "A"
str_view_all(strings, "A{2}", T)

## two or more times "A"
str_view_all(strings, "A{2,}", T)

## between two and three "A"
str_view_all(strings, "A{2,3}", T)


## Exercises with sentences
## count the number of words in each sentences
## first remove all punctuation and convert to lower case
## then then count the number of words and show results
sentences.df1 <- sentences.df %>% 
  mutate(sentence = str_remove_all(sentence, "[:punct:]"),
         sentence = str_to_lower(sentence)) %>% 
  mutate(`nr words` = str_count(sentence, "\\s+") + 1)


## countries with more than 3 words in a country name
countries.df %>% 
  mutate(`nr words` = str_count(country, "\\s+") + 1) %>% 
  filter(`nr words` > 3)
