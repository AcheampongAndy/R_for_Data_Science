# reset work space
rm(list = ls())

# load libraries
library(readr)

# read files

# read inline csv files
read_csv("c1,c2,c3
         1,a,T
         2,b,T
         3,c,F",
         show_col_types = F)

# inline files with meta header lines
read_csv("First meta line
          Second meta line
          c1,c2,c3
          1,a,T
          2,b,T
          3,c,F", skip = 2,
         show_col_types = F)

# inline files with comment
read_csv("c1,c2,c3 # comment
          1,a,T    # comment
          2,b,T
          3,c,F", comment = "#",
         show_col_types = F)


# read comma separated files - .csv from your local drive
list.files(path = "./data")

# small mpg table
df <- read_csv(file = "./data/mpg_mini.csv",
               show_col_types = F)

# small mpg table - column separator ";"
df <- read_csv2(file = "./data/mpg_mini2.csv",
                show_col_types = F)

# read tab delimited file - .tsv
df <- read_tsv(file = "./data/mpg.tsv",
               show_col_types = F)

# read files with selected / custom delimiter
df <- read_delim(file = "./data/mpg_delim.txt",
                 delim = "~",
                 show_col_types = F)

# read text files 
df <- read_delim(file = "./data/mpg.txt",
                 col_names = T,
                 skip = 3,
                 skip_empty_rows = T,
                 delim = " ",
                 quote = "\"",
                 show_col_types = F
                 )


# read log file
df <- read_log(file = "./data/example.log")

# read a large csv file (check execution time)
system.time(
  df <- read.csv(file = "./data/mpg_maxi.csv")
)

system.time(
  df <- read_csv(file = "./data/mpg_maxi.csv",
                 show_col_types = F)
)