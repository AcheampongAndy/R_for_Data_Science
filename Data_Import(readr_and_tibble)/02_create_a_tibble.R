# reset work space
rm(list = ls())

# load libraries
library(tibble)
library(hflights)

# Create tibble

# as_tibble() 

## convert hflights data frame to tibble
class(hflights)
dft <- as_tibble(hflights)
class(df)


# convet a custom data frame
df <- data.frame(x = 1:10,
                 y = seq.Date(from = as.Date("2022-01-01"),
                              to = as.Date("2022-01-10"),
                              by = "day"))
df
class(df)
dft <- as_tibble(df)
dft
class(dft)


# tibble ()
tibble(var1 = seq(from = 1, to = 100, by = 1),
       var2 = pi,
       var3 = sqrt(var1),
       var4 = seq.Date(from = as.Date("2022-01-01"),
                       length.out = 100,
                       by = "day"))

## some strange names
tibble(`123` = 123,
       `.` = "period",
       `,` = "comma",
       `#$^&(*&^%` = "strange characters")

## tribble () 
tribble(
  ~name, ~surname, ~male, ~age, #header
  "Max", "Smith", T, 34,
  "Lilly", "Brown", F, 24
)
