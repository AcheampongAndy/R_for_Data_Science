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

# Digits Vs non digits
strings <- c(letters, "123", "1-5-6", "598642")

## find strings with digits
str_subset(strings, "\\d")
str_view_all(strings, "\\d", match = T)

## find strings without digits
str_subset(strings, "\\D")
str_view_all(strings, "\\D", match = T)

## strings with pattern: "digit-digit-digit"
str_subset(strings, "\\d-\\d-\\d")
str_view_all(strings, "\\d-\\d-\\d", T)


# Locate white spaces
set.seed(123)
strings <- c(sample(sentences, 5),
             sample(fruit, 5),
             sample(words, 5),
             "This is \nnew line",
             "String with a tab \t")

## locate string with white space(s)
str_subset(strings, " ") # or
str_subset(strings, "\\s") # or
str_view_all(strings, "\\s", T)

## locate strings with new lines or tabs
str_subset(strings, "\\n")
str_subset(strings, "\\t")


# Different classes
strings <- c("123abc", "abc", "123", ".,?", "ABC", "\nABC", "\tabc")

## digits
str_subset(strings, "[:digit:]")
str_view_all(strings, "[:digit:]", T)

## letters
str_subset(strings, "[:alpha:]")
str_view_all(strings, "[:alpha:]", T)

## upper / lower case letters
str_subset(strings, "[:lower:]")
str_view_all(strings, "[:lower:]", T)

str_subset(strings, "[:upper:]")
str_view_all(strings, "[:upper:]", T)

## letters or numbers
str_subset(strings, "[:alnum:]")
str_view_all(strings, "[:alnum:]", T)

## string with punctuation
str_subset(strings, "[:punct:]")
str_view_all(strings, "[:punct:]", T)

## letters, numbers, punctuations
str_subset(strings, "[:graph:]")
str_view_all(strings, "[:graph:]", T)

## strings with space characters
str_subset(strings, "[:blank:]")
str_view_all(strings, "[:blank:]", T)
