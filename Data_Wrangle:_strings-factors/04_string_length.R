# clear work space
rm(list = ls())

# load libraries
library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr)

# load string data set
load("./data/strings.RData")

# str_length ()
# base R: nchar ()

## length of fruit names
str_length(string = fruit)

## get all fruits with 10 or more character fruit names
fruit[str_length(string = fruit) >= 10]

# str_pad () 

## pad fruit name with symbol "X" to get string with 20 characters
str_pad(fruit, 20, "left", "X")


# str_trunc()

## truncate fruit name with symbol "..." to get string with width = 5
str_trunc(fruit, 5, "left", "...")

# str_trim()

## create a string with white spaces
whitespaces <- c("nowhitespace",
                 " leftspace",
                 "   leftspace",
                 "       leftspace",
                 "rightspace ",
                 "rightspace   ",
                 "rightspace     ",
                 "rightspace        ",
                 "   bothspace         ",
                 "         bothspace    ",
                 "   bothspace            ",
                 "              bothspace    ",
                 "midle  space",
                 " mix space  ")
whitespaces
# trimming...
str_trim(whitespaces, "left")
str_trim(whitespaces, "right")
str_trim(whitespaces, "both")

