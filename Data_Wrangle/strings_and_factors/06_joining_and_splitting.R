# clear work space
rm(list = ls())

# load libraries
library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr)

# load string data set
load("./data/strings.RData")

# str_c () - join multiple strings

## split vector fruit into 4 equal in size smaller vectors
fruit1 <- fruit[1:20]
fruit2 <- fruit[21:40]
fruit3 <- fruit[41:60]
fruit4 <- fruit[61:80]

## create one vector using 4 smaller vectors
str_c(fruit1, fruit2, fruit3, fruit4, sep = "-")

## create a vector of alphabet letters: one lower case and one upper case.
letters
Letters
str_c(letters, Letters, sep = " ")


# str_dup () - repeate string multiple times

## repeate one string 5 times
str_dup("word", 5)

## repeat a vector of strings 2 times
str_dup(fruit2, 2)


# str_split_fixed () - split a vector of strings into a matrix of sub strings based on the pattern

## split fruit by " "
str_split_fixed(fruit, " ", 2)

## split first 5 sentences by " " and increase n
sentences
str_split_fixed(sentences, " ", 10)


# str_split () - split a vector of strings into a list / matrix substrings

## split first 5 sentences by " "
str_split(sentences[1:5], " ")


# str_glue () - glue/merge string and expression

## merge string and evaluate mathematical symbol
str_glue("what is the value of sqrt(2), it is {round(sqrt(2), 3)}")

## merge fixed string and assigned string to a variable
name <- "Andy"
str_glue("Hi my is {name}")


# str_glue_data () - use df / list or environment to create strings from string expression

## merge string and values form df
mtcars
str_glue_data(mtcars, "The car {rownames(mtcars)}: {hp} horsepower, {cyl} number of cylinders, and consumption {mpg} is miles per gallon")
