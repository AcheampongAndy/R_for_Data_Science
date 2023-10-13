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

# list of special characters
?"'"

# escaping paradox
string <- c("string", "word", "letter", "word.letter", "character/letter")

str_view(string, "tr")

## match ".t." any character before "t" and any character after "t"
str_view(string, ".t.")
str_view_all(string, ".t.")

## match dot "." as dot and not a special character
str_view(string, "\\.")

## match a backslash as backslash and not a special character
str_view("\\", "\\\\")
writeLines("\\\\")
