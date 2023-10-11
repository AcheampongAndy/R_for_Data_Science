# clear work space
rm(list = ls())

# load libraries
library(forcats)
library(ggplot2)
library(dplyr)

# fct_c () - for combing factors

# lets create factor variables
df <- mpg %>%
  mutate_at(.vars = c("manufacturer", "model", "trans", "class"),
            .funs = as_factor)

## split cars into two data frames
manufacturers <- df %>% 
  .$manufacturer %>% 
  fct_unique() %>% 
  as.character()

df1 <- df %>% 
  filter(manufacturer %in% manufacturers[1:8])

df2 <- df %>% 
  filter(manufacturer %in% manufacturers[9:15])

## extract only factor vectors
f1 <- df1 %>% pull(manufacturer)
f2 <- df2 %>% pull(manufacturer)

levels(f1)
levels(f2)

## combine factors
fct_c(f1, f2)

## lets randomly shuffle levels
set.seed(478)
manufacturer.rmd <- sample(manufacturers, size = length(manufacturers), replace = F)

## now count frequencies
df %>% 
  mutate(manufacturer = fct_relevel(manufacturer, manufacturer.rmd)) %>% 
  count(manufacturer)

# fct_infreg () 

## order manufacturer base on car count
df %>% 
  mutate(manufacturer = fct_infreq(manufacturer)) %>% 
  count(manufacturer)

# fct_inorder ()
df %>% 
  mutate(manufacturer = fct_inorder(manufacturer)) %>% 
  count(manufacturer)

# fct_rev ()
df %>% 
  mutate(manufacturer = fct_rev(manufacturer)) %>% 
  count(manufacturer)

## to get reverse frequency count: fct_freq + fct_rev
df %>% 
  mutate(manufacturer = fct_infreq(manufacturer),
         manufacturer = fct_rev(manufacturer)) %>% 
  count(manufacturer)
