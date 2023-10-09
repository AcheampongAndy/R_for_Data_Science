# clear work space
rm(list = ls())
graphics.off()

# load libraries
library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr)

# strings in tidyverse

## create strings
s1 <- "string"
s1

s2 <- 'string'
s2

s3 <- "word, 'string' "
s3

s4 <- 'word, "string" '
s4


# create a vector of strings
vec <- c("a", "b", "c")
vec

# character vector inside tibble as column
df <- tibble(letters = vec)
df


# special characters 
## how to escape special characters
"\""
'\''
"\n" # new line
"\t" # tab

## Unicode non-English letters
"\u03B1"


# see raw content of your string
s <- "string"
s
writeLines(s)

s <- "\""
s
writeLines(s)

s <- "line 1 \nline 2"
s
writeLines(s)
