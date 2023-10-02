# reset work space
rm(list = ls())

# load libraries
library(dplyr)
library(tidyr)
library(stringr)
library(hflights)

# Inspect data
df <- hflights

# Transform table holding flights data

## count number of rows, columns
nrow(hflights); ncol(hflights)

## how many columns begin with the word "Taxi"
df %>% 
  select(starts_with("Taxi"))

## how many flights were flown with less than 1000 miles / greater or equal to 1000 miles
df %>% 
  mutate(dist1000 = case_when(Distance <  1000 ~ "< 1000 miles",
                              Distance >= 1000 ~ ">= 1000 miles")) %>% 
  count(dist1000)

## how many flights per carrier - sort by top to bottom
df %>% 
  group_by(UniqueCarrier) %>% 
  count() %>% 
  ungroup() %>% 
  arrange(desc(n))

## number of canceled flight per each carrier
df %>% count(Cancelled)
df %>% filter(Cancelled == 1) %>% 
  group_by(UniqueCarrier) %>% 
  count() %>% 
  ungroup() %>% 
  arrange(desc(n))


## percentage of cancelled flight per each carrier
df %>% 
  # count flight break down by cancellation
  group_by(UniqueCarrier, Cancelled) %>%
  count() %>% 
  ungroup() %>% 
  # calculate total flight
  group_by(UniqueCarrier) %>% 
  mutate(`n total` = sum(n)) %>% 
  ungroup() %>% 
  # calculate percentages
  mutate(`n percent` = (n / `n total`) * 100) %>% 
  filter(Cancelled == 1) %>% 
  select(-n, -`n total`) %>% 
  arrange(desc(`n percent`))


## create a column date by combing year + month + dayofMonth (remove these columns)
df <- df %>% 
  mutate_at(.vars = c("Month", "DayofMonth"),
            .funs = str_pad, 2, "left", "0") %>% 
  unite(col = "date", Year, Month, DayofMonth,
        sep = "-")

## count flights per cancelled codes (codes in columns)
## and per carriers (in rows)
## pivoting is required
df %>% count(CancellationCode)
df %>% 
  mutate(CancellationCode = case_when(CancellationCode == "" ~ "0",
                                      TRUE ~ CancellationCode)) %>% 
  group_by(UniqueCarrier, CancellationCode) %>% 
  count() %>% 
  ungroup() %>% 
  pivot_wider(names_from = CancellationCode, 
              values_from = n,
              values_fill = 0)
