# clear work space
rm(list = ls())

# load libraries
library(forcats)
library(stringr)
library(ggplot2)
library(dplyr)
library(forcats)
library(tibble)

# lets create factor variables
df <- mpg %>%
  mutate_at(.vars = c("manufacturer", "model", "trans", "class"),
            .funs = as_factor)

# fct_recode () 

## first lets pull levels and add country of origin
df %>% pull(manufacturer) %>% fct_count()

levels.country <- tribble( # table of: company & country of origin
  ~company,    ~country,
  "audi",          "Germany",
  "chevrolet",     "USA",
  "dodge",         "USA",
  "ford",          "USA",
  "honda",         "Japan",
  "hyundai",       "South Korea",
  "jeep",          "USA",
  "land rover",    "England",
  "lincoln",       "USA",
  "mercury",       "USA",
  "nissan",       "Japan",
  "pontiac",       "USA",
  "subaru",        "Japan",
  "toyota",        "Japan",
  "volkswagen",    "Germany")


## prepare pairs for re-coding factor levels
levels.country %>% 
  mutate(recode = str_c(country, " = ", "'", company, "'", sep = "")) %>% 
  pull(recode) %>% 
  str_c(., collapse = ", ")

df.recode <- df %>% 
  mutate(manufacturer = fct_recode(manufacturer, 
                                   Germany = 'audi', 
                                   USA = 'chevrolet', 
                                   USA = 'dodge', 
                                   USA = 'ford', 
                                   Japan = 'honda', 
                                   `South Korea` = 'hyundai', 
                                   USA = 'jeep', 
                                   England = 'land rover', 
                                   USA = 'lincoln', 
                                   USA = 'mercury', 
                                   Japan = 'nissan', 
                                   USA = 'pontiac', 
                                   Japan = 'subaru', 
                                   Japan = 'toyota', 
                                   Germany = 'volkswagen'))

df.recode %>% 
  count(manufacturer)


# fct_collapse ()

## lets keep only USA companies others are collapse
non.US.manufacturer <- levels.country %>% 
  filter(country != "USA") %>% 
  pull(company)

df.collapse <- df %>% 
  mutate(manufacturer = fct_collapse(manufacturer, `non US` = non.US.manufacturer))

df.collapse %>% 
  count(manufacturer)


# fct_other ()

## all non US companies put into other
df.other <- df %>% 
  mutate(manufacturer = fct_other(manufacturer, drop = non.US.manufacturer))

df.other %>% 
  count(manufacturer)


# fct_drop ()

## drop other level
## -first filter out row with "other"
df.drop <- df.other %>% 
  filter(manufacturer != "Other")

## check levels - other still present
df.drop %>% pull(manufacturer) %>% fct_unique()

## now drop levels
df.drop <- df.drop %>% 
  mutate(manufacturer = fct_drop(manufacturer))

df.drop %>% pull(manufacturer) %>% fct_unique()


# fct_expand ()

## lets add some additional manufacturer 
df.expand <- df %>% 
  mutate(manufacturer = fct_expand(manufacturer, c("Ferrari", "Lamborghini")))

## check levels
df.expand %>% pull(manufacturer) %>% fct_unique()
df.expand %>% pull(manufacturer) %>% levels()

## at the moment we dont have any cars from "Ferrari", "Lamborghini"
## just the levels are prepared in advance for future
df.expand %>% filter(manufacturer %in% c("Ferrari", "Lamborghini"))
