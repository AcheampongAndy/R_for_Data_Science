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

# Anchors

## find words that start with "a"
str_subset(words, "^a")
str_view_all(words, "^a", T)

## find words that end with "a"
str_subset(words, "a$")
str_view_all(words, "a$", T)

## find exact word: ^.....$
str_subset(words, "^actor$")
str_view_all(words, "^actor$", T)

str_subset(words, "^lemon$")
str_view_all(words, "^lemon$", T)



# Alternates

## find words that start with "af" or "ag"
str_subset(words, "^af|^ag")
str_view_all(words, "^af|^ag", T)

## find words containing letters "x" or "y" or "z"
str_subset(words, "[xyz]")
str_view_all(words, "[xyz]", T)

## find words not containing letters "a" to "x"
str_subset(words %>% str_to_lower(), "[^[a-y]]")
str_view_all(words %>% str_to_lower(), "[^[a-y]]", T)

## find all country names that begins with letter "A" or "E"
str_subset(countries, "^A|^E")
str_view_all(countries, "^A|^E", T)

## find all country names that ends with letter "a" or "e"
str_subset(countries, "a$|e$")
str_view_all(countries, "a$|e$", T)


# Groups

## find all sentences that include words: "the", "a", or "an"
str_subset(sentences, "\\sthe\\s|\\sa\\s|\\san\\s")
str_view_all(sentences, "\\sthe\\s|\\sa\\s|\\san\\s", T)

## find words with repeated pair of letters (two letters must be repeated)
str_subset(words, "(..)\\1") # \1 is a group reference 1st group
str_view_all(words, "(..)\\1", T)

## more than one group in back reference
strings <- c("abc", "abcabc", "ababcc", "abababccc")
str_view_all(strings, "(a)(b)", T) #ab
str_view_all(strings, "(a)(b)\\1", T)  #aba
str_view_all(strings, "(a)(b)\\1\\2", T)  #abab
str_view_all(strings, "(a)(b)\\1\\2\\1\\2", T)  #ababab
