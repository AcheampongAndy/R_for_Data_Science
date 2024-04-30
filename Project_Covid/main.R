# 9 case study: Explore Covid-19 in USA

rm(list = ls())
graphics.off()

# load libraries
library(tidyverse)
library(lubridate)
library(cowplot)
library(rio)
library(janitor)
library(tidystringdist)
library(zoo)

# custom functions
source('functions.R')

# 1) Data Imports

path.origin <- './data/'

# 1a) Covid-19 data 
data.dir.name.Covid19 <- list.files(path = path.origin) %>% str_subset('^csse')

## do the actual import 
df.COVID19 <- tibble(directory = paste0(path.origin, data.dir.name.Covid19),
                     file = list.files(path = directory)) %>% 
  mutate(path = str_c(directory, file, sep = '/')) %>% 
  mutate(data = map(.x = path,
                    .f = function(path_){
                      read_csv(path_,
                               col_types = cols(.default = 'c'))
                    })) %>% 
  mutate(date = str_remove(string = file, pattern = '//.csv'),
         date = mdy(date)) %>% 
  select(date, data) %>% 
  unnest(cols = 'data') %>% 
  clean_names()

# data cleaning
df.COVID19 <- df.COVID19 %>% 
  # column conversion
  mutate(last_update = ymd_hms(last_update)) %>% 
  mutate_at(.tbl  = .,
            .vars = setdiff(colnames(.)[5:ncol(.)], 'iso3'),
            .funs = as.numeric) %>% 
  rename(state = province_state)


# 1b) GDP data
data.dir.names.GDP <- list.files(path = path.origin) %>% str_subset(pattern = 'GDP')
df.GDP <- rio::import(file = paste0(path.origin, '/', data.dir.names.GDP),
                      sheet = 'clean data') %>% 
  clean_names()

## column selection and cleaning
df.GDP <- df.GDP %>% 
  select(state = state_or_territory, 
         gdp_norminal = nominal_gdp_2020,
         gdp_per_capital = gdp_per_capita_2020) %>% 
  # columns convertion
  mutate_all(.funs = function(x) str_remove_all(x, ',|//$')) %>% 
  mutate(gdp_per_capital = str_sub(gdp_per_capital, start = 2, 
                                   end = length(gdp_per_capital))) %>% 
  mutate_at(., .vars = colnames(.)[2:3], .funs = as.numeric)


# 1c) Population
data.dir.name.Pop <- list.files(path.origin) %>% str_subset('Population')
df.Population <- rio::import(file = paste0(path.origin, '/', data.dir.name.Pop)) %>% 
  clean_names()

# column selection and cleaning
df.Population <- df.Population %>% 
  select(state = name,
         pop = pop_2019)


# 1d) Covid response tracker
data.dir.name.response <- list.files(path.origin) %>% str_subset('US_latest')

df.COVID19.response <- read_csv(file = paste0(path.origin, '/', 
                                              data.dir.name.response),
                                col_types = cols(.default = 'c')) %>% 
  clean_names()

## column selection and cleaning
df.COVID19.response <- df.COVID19.response %>% 
  mutate(date = ymd(date)) %>% 
  select(state = region_name,
         date,
         contains('index')) %>% 
  mutate_at(.tbl = .,
            .vars = colnames(.)[3:ncol(.)],
            .funs = as.numeric)


# 1e) covid vaccination
data.dir.name.vaccine <- list.files(path.origin) %>% str_subset('vaccine')

df.COVID19.vacc <- read_csv(file = paste0(path.origin, '/', 
                                          data.dir.name.vaccine),
                            col_types = cols(.default = 'c')) %>% 
  clean_names()

# column selection and cleaning
df.COVID19.vacc <- df.COVID19.vacc %>% 
  mutate(date = ymd(day),
         daily_vacc = as.numeric(daily_vaccinations)) %>% 
  select(state = entity,
         date,
         vaccine = daily_vacc)

# 2) Initial data inspection
# Check
# missing values
# time spans
# relevant data
# how data is coded

## missing values
count_NA(df.COVID19)
count_NA(df.GDP)
count_NA(df.Population)
count_NA(df.COVID19.response)
count_NA(df.COVID19.vacc)

## time spans
check_time_span(df.COVID19)
check_time_span(df.COVID19.response)
check_time_span(df.COVID19.vacc)

# check for main data set
## we are interested in (confirmed, death, recovered, active)
## how data is coded
## is data consistence
## check on USA level and on state level

### state level
df.COVID19 %>% 
  select(date, state, confirmed:active) %>% 
  filter(state == 'Alabama') %>% 
  # convert table from wide to long
  pivot_longer(cols = c('confirmed', 'deaths', 'recovered', 'active'),
               names_to = 'variable',
               values_to = 'values') %>% 
  ggplot(aes(x = date,
             y = values,
             color = variable)) +
  geom_point() +
  facet_grid(variable ~ .,
             scales = 'free')
  

### national level
df.COVID19 %>% 
  select(date, state, confirmed:active) %>% 
  # convert table from wide to long
  pivot_longer(cols = c('confirmed', 'deaths', 'recovered', 'active'),
               names_to = 'variable',
               values_to = 'values') %>% 
  # aggregate on a date and variable level
  group_by(date, variable) %>% 
  summarise(values = sum(values, na.rm = T)) %>% 
  ggplot(aes(x = date,
             y = values,
             color = variable)) +
  geom_point() +
  facet_grid(variable ~ .,
             scales = 'free')

### what is obvious in main data set
### all data regarding COVID19 Infections
### is reported as running total
### confirmed and deaths are recorded consistently
### while active and recorded are inconsistent
### we will focus on confirmed and deaths


# main table:
## - single table
## - one row equal to one state per one date
## - all relevant variables are in the table
## - steps:
### - Universal list of US states
### - generate all relevant dates
### - combine states and dates
### - bring all relevant data from sources to master table

## US states list
## - check names
## - we will create a list of 50 names
## - create a function
###   - match state names
###   - from each state
###   - with the states from the list
###   - states name match is made 'string similarity matching'

## list of states names
states.list <- tibble(state_base = datasets::state.name)

# do states name matching
states.list.COVID19 <- state_matching(data = df.COVID19, col_name = "state.COVID19")
states.list.GDP <- state_matching(data = df.GDP, col_name = "state.GDP")
states.list.Pop <- state_matching(data = df.Population, col_name = "state.Pop")
states.list.COVID19.response <- state_matching(data = df.COVID19.response, 
                                               col_name = "state.COVID19.response")
states.list.COVID19.vacc <- state_matching(data = df.COVID19.vacc, 
                                           col_name = "state.COVID19.vacc")

# create one universal list by joining lists
states.list <- states.list.COVID19 %>% 
  inner_join(x = .,
             y = states.list.GDP,
             by = 'state_base') %>% 
  inner_join(x = .,
             y = states.list.Pop,
             by = 'state_base') %>% 
  inner_join(x = .,
             y = states.list.COVID19.response,
             by = 'state_base') %>% 
  inner_join(x = .,
             y = states.list.COVID19.vacc,
             by = 'state_base') %>% 
  arrange(state_base) %>% 
  mutate(state_id = row_number()) %>% 
  select(state_id, everything())

### name fix
states.list.COVID19.vacc %>% filter(state_base %in% c("New Jersy", "New York"))
states.list[states.list$state_base == 'New York', 'state.COVID19.vacc'] <- 'New York State'

## add state region
states.region <- tibble(state_base = state.name,
                        region = state.region)

## states table
df.states <- states.list %>% 
  left_join(x = .,
            y = states.region,
            by = "state_base")

## relevants dates
df.dates <- tibble(date = seq.Date(from = df.COVID19 %>% pull(date) %>% min(),
                                   to = df.COVID19 %>% pull(date) %>% max(),
                                   by = 'day'))

## create a main table
df.main <- df.states %>% 
  full_join(x = .,
            y = df.dates,
            by = character())

## check
df.main %>% count(state_base) %>% as.data.frame()

## bring data from sources to our main table
df.main <- df.main %>% 
  left_join(x = .,
            y = df.COVID19 %>% select(state, date, confirmed, deaths),
            by = c('state.COVID19' = 'state', 'date' = 'date')) %>% 
  left_join(x = .,
            y = df.GDP,
            by = c('state.GDP' = 'state')) %>% 
  left_join(x = .,
            y = df.Population,
            by = c('state.Pop' = 'state')) %>% 
  left_join(x = .,
            y = df.COVID19.vacc,
            by = c('state.COVID19.vacc' = 'state', 'date' = 'date')) %>% 
  left_join(x = .,
            y = df.COVID19.response,
            by = c('state.COVID19.response' = 'state', 'date' = 'date')) %>% 
  select(state_id,
         state = state_base,
         region, 
         date,
         `confirmed total` = confirmed,
         `deaths total` = deaths,
         `daily vaccine doses` = vaccine,
         everything()) %>% 
  rename(population = pop) %>% 
  arrange(state, date)

# remove some columns
df.main <- df.main %>% select(-c('state.COVID19', 'state.GDP', 'state.Pop', 'state.COVID19.vacc', 
 'state.COVID19.response'))

# additional data wrangling
## - population in millions
## - daily counts
## - negative values
## - flag first data when vaccination detected
## - vaccination missing after first date
## - check for missing data in general

## non vaccination data missing
df.main %>% filter(is.na(`confirmed total`)) %>% nrow()
df.main %>% filter(is.na(`deaths total`)) %>% nrow()


## vaccination starting date
df.main %>% filter(is.na(`daily vaccine doses`)) %>% nrow()

df.state.vacc.date.min <- df.main %>% 
  filter(!is.na(`daily vaccine doses`)) %>% 
  group_by(state) %>% 
  summarise(min_date = min(date)) %>% 
  ungroup()

### replace NAs | daily counts | total counts
df.main <- df.main %>% 
  mutate(population_in_million = round(population / 10**6, 2)) %>% 
  mutate(daily_vaccine_doses = replace_na(`daily vaccine doses`, 0)) %>% 
  select(-`daily vaccine doses`) %>% 
  # daily count
  group_by(state) %>% 
  mutate(confirmed_daily_cases = `confirmed total` - lag(`confirmed total`, 1),
         deaths_daily_cases = `deaths total` - lag(`deaths total`, 1)) %>% 
  # total counts for vaccine
  mutate(vaccine_doses_total = cumsum(daily_vaccine_doses)) %>% 
  ungroup() %>% 
  # rearranging columns
  select(state_id:date,
         `confirmed total`, confirmed_daily_cases,
         `deaths total`, deaths_daily_cases,
         daily_vaccine_doses, vaccine_doses_total,
         everything())

### check negative values
df.main %>% filter(confirmed_daily_cases < 0)
df.main %>% filter(deaths_daily_cases < 0)
df.main %>% filter(daily_vaccine_doses < 0)

df.main <- df.main %>% 
  mutate(confirmed_daily_cases = case_when(confirmed_daily_cases >= 0 ~ confirmed_daily_cases,
                                           T ~ 0),
         deaths_daily_cases = case_when(deaths_daily_cases >= 0 ~ deaths_daily_cases,
                                           T ~ 0),
         daily_vaccine_doses = case_when(daily_vaccine_doses >= 0 ~ daily_vaccine_doses,
                                           T ~ 0))

# 4) EDA
# - answer some questions
# - some data wrangling

## states per region
df.main %>% 
  group_by(region) %>% 
  summarise(state = n_distinct(state)) %>% 
  ungroup()

## show state on map
max_date <- df.main %>% pull(date) %>% max(.)

## state to lower case
df.main <- df.main %>% 
  mutate(state_ = str_to_lower(state))

## map
df.main %>% 
  filter(date == max_date) %>% 
  # longitude and latitude
  left_join(x = .,
            y = map_data('state'),
            by = c('state_' = 'region')) %>% 
  ggplot(aes(x = long,
             y = lat,
             group = group)) +
  geom_polygon(aes(fill = region),
               color = 'black') +
  xlab('') +
  ylab('') +
  ggtitle('') +
  theme_bw() +
  theme(axis.ticks = element_blank(),
        axis.text = element_blank())

## Questions?
## What is happening, with total number of infect, over time on state level?
## What is happening, with total number of deaths, over time on state level?

### relative counts
df.main <- df.main %>% 
  mutate(`confirmed total %` = `confirmed total` / population,
         `deaths total %` = `deaths total` / population)

### add region groups
df.region.group <- df.main %>% 
  group_by(region) %>% 
  count(state) %>% 
  ungroup() %>% 
  arrange(region, state) %>% 
  # add state count
  group_by(region) %>% 
  mutate(states = n(),
         id = row_number()) %>% 
  ungroup() %>% 
  # add group id
  mutate(group = case_when(id <= round(states / 2, 0) ~ 1,
                           T ~ 2)) %>% 
  mutate(`region - group` = paste0(region, ' - group ', group)) %>% 
  select(region, state, `region - group`)

## bring groups to main table
df.main <- df.main %>% 
  left_join(x = .,
            y = df.region.group %>% select(-region),
            by = 'state')


## plot for each region and group
region.groups <- df.region.group %>% distinct(`region - group`) %>% pull(`region - group`)
map(.x = region.groups, .f = plot_confirmed_cases_total)


# Questions
# Which state paid the highest price considering confirmed cases and deaths (relative counts)

## bar chart
df.main %>% 
  filter(date == max_date) %>% 
  select(region, state, `confirmed total %`, `deaths total %`) %>% 
  # pivot
  pivot_longer(cols = c("confirmed total %", "deaths total %"),
               names_to = 'count',
               values_to = 'value') %>% 
  # sort states
  group_by(state) %>% 
  mutate(tot_percentage = sum(value)) %>% 
  ungroup() %>% 
  arrange(tot_percentage, state) %>% 
  mutate(state = as.factor(state),
         state = fct_inorder(state)) %>% 
  # plot
  ggplot(aes(y = state,
             x = value, 
             fill = region)) +
  geom_col(color = 'black') +
  facet_wrap(count ~ .,
             scales = 'free') +
  xlab('% of state population') +
  ylab('State') +
  ggtitle('Confirmed cases and deaths relative count') +
  scale_fill_viridis_d() 
  #theme_minimal()

ggsave(filename = paste0('./explore/01_relative_count_confirmed_cases_deaths_last_date.png'),
       plot = last_plot(),
       width = 30,
       height = 20, 
       units = 'cm')

## create map (relative map)
p1 <- df.main %>% 
  filter(date == max_date) %>% 
  #select(region, state, `confirmed total %`, `deaths total %`) %>% 
  # map data
  left_join(x = .,
            y = map_data('state'),
            by = c('state_' = 'region')) %>% 
  ggplot(aes(x = long,
             y = lat,
             group = group)) +
  geom_polygon(aes(fill = `deaths total %`),
               color = 'black') +
  xlab('') +
  ylab('') +
  ggtitle('Percentage of deaths vrs state population') +
  scale_fill_gradient(low = 'white', high = 'black') +
  theme_bw() +
  theme(axis.ticks = element_blank(),
        axis.text = element_blank())


p2 <- df.main %>% 
  filter(date == max_date) %>% 
  #select(region, state, `confirmed total %`, `deaths total %`) %>% 
  # map data
  left_join(x = .,
            y = map_data('state'),
            by = c('state_' = 'region')) %>% 
  ggplot(aes(x = long,
             y = lat,
             group = group)) +
  geom_polygon(aes(fill = `confirmed total %`),
               color = 'black') +
  xlab('') +
  ylab('') +
  ggtitle('Percentage of confirmed cases vrs state population') +
  scale_fill_gradient(low = 'white', high = 'red') +
theme_bw() +
  theme(axis.ticks = element_blank(),
        axis.text = element_blank())

plot_grid(p1, p2, nrow = 2)
# export plot 
ggsave(filename = paste0('./explore/02_map_relative_count_confirmed_cases_deaths_last_date.png'),
       plot = last_plot(),
       width = 30,
       height = 20, 
       units = 'cm')

## Questions?
## Are daily dynamics change over time
## - daily confirmed cases
## - daily deaths

### lets calculate 7day average
df.main <- df.main %>% 
  arrange(state, date) %>% 
  group_by(state) %>% 
  mutate(`confirmed daily cases 7day avg` = rollapply(confirmed_daily_cases,
                                                      FUN = mean,
                                                      width = 7,
                                                      align = 'right',
                                                      fill = NA)) %>% 
  mutate(`death cases 7day avg` = rollapply(deaths_daily_cases,
                                                      FUN = mean,
                                                      width = 7,
                                                      align = 'right',
                                                      fill = NA)) %>% 
  ungroup()

## plot
map(.x = region.groups,
    .f = plot_confirmed_deaths_cases_7d_avg)

### Question?
## Do state wealth and/or 
## state population have effect on total percentage of confirmed cases and death
df.main %>% 
  filter(date == max_date) %>% 
  ggplot(aes(x = `confirmed total %`,
             y = `deaths total %`,
             size = population_in_million,
             color = gdp_per_capital)) +
  geom_point(alpha = 0.75,
             show.legend = T) +
  facet_wrap(. ~ region) +
  scale_color_gradient(low = 'brown1', high = 'green') +
  scale_size_area(max_size = 40) +
  xlab('Tot confirmed cases %') +
  ylab('Tot deaths %') +
  ggtitle('Total confirmed % and total deaths % VS GDP  and population') +
  theme_bw()

ggsave(filename = paste0('./explore/04_confirmed_deaths_perc_gdp_pop_scatter.png'),
       plot = last_plot(),
       width = 30,
       height = 20, 
       units = 'cm')


### Question?
## Does vaccination help to decrease COVID 19 confirmed cases and deaths total?
map(.x = region.groups,
    .f = plot_confirmed_deaths_cases_7d_avg_vaccine_doses_total)

## Question?
## Show on map how number of COVID cases have change over time

## add date ids and snapshoot flags
df.main <- df.main %>% 
  arrange(state, date) %>% 
  # date id per state
  group_by(state) %>% 
  mutate(date_id = row_number()) %>% 
  ungroup() %>% 
  # add snapshoot flag for every 30th day
  mutate(date_snaptshoot_flag = case_when(date_id == 1 ~ TRUE,
                                          date == max_date ~ TRUE,
                                          date_id %% 30 == 0 ~ TRUE,
                                          T ~ FALSE))

## map
df.main %>% 
  filter(date_snaptshoot_flag) %>% 
  #select(region, state, `confirmed total %`, `deaths total %`) %>% 
  # map data
  left_join(x = .,
            y = map_data('state'),
            by = c('state_' = 'region')) %>% 
  ggplot(aes(x = long,
             y = lat,
             group = group)) +
  geom_polygon(aes(fill = `deaths total`),
               color = 'black') +
  facet_wrap(. ~ date) +
  xlab('') +
  ylab('') +
  ggtitle('Number of confirmed total cases over time') +
  scale_fill_gradient(low = 'white', high = 'red') +
  theme_bw() +
  theme(axis.ticks = element_blank(),
        axis.text = element_blank())

ggsave(filename = paste0('./explore/06_map_total_count_confirmed_cases_over_time.png'),
       plot = last_plot(),
       width = 30,
       height = 20, 
       units = 'cm')


## Question?
## Show on map how total number of vaccine doses has increased over time

## map
df.main %>% 
  filter(date_snaptshoot_flag) %>% 
  #select(region, state, `confirmed total %`, `deaths total %`) %>% 
  # map data
  left_join(x = .,
            y = map_data('state'),
            by = c('state_' = 'region')) %>% 
  ggplot(aes(x = long,
             y = lat,
             group = group)) +
  geom_polygon(aes(fill = vaccine_doses_total),
               color = 'black') +
  facet_wrap(. ~ date) +
  xlab('') +
  ylab('') +
  ggtitle('Number of vaccine doses over time') +
  scale_fill_gradient(low = 'white', high = 'deepskyblue3') +
  theme_bw() +
  theme(axis.ticks = element_blank(),
        axis.text = element_blank())

ggsave(filename = paste0('./explore/07_map_total_count_vaccine_doses_over_time.png'),
       plot = last_plot(),
       width = 30,
       height = 20, 
       units = 'cm')


## Question?
## How high was the response rate (precaution measurement) of each state towards pandemic

## map
df.main %>% 
  filter(date_snaptshoot_flag) %>% 
  #select(region, state, `confirmed total %`, `deaths total %`) %>% 
  # map data
  left_join(x = .,
            y = map_data('state'),
            by = c('state_' = 'region')) %>% 
  ggplot(aes(x = long,
             y = lat,
             group = group)) +
  geom_polygon(aes(fill = stringency_legacy_index_for_display),
               color = 'black') +
  facet_wrap(. ~ date) +
  xlab('') +
  ylab('') +
  ggtitle('State response rate over time') +
  scale_fill_viridis_c(option = 'magma') +
  theme_bw() +
  theme(axis.ticks = element_blank(),
        axis.text = element_blank())

ggsave(filename = paste0('./explore/08_map_state_response_rate.png'),
       plot = last_plot(),
       width = 30,
       height = 20, 
       units = 'cm')


## Questions?
## How selected State is doing?

## Vaccine smoothed daily count
df.main <- df.main %>% 
  arrange(state, date) %>% 
  group_by(state) %>% 
  mutate(`daily vaccine dosses 7day avg` = rollapply(daily_vaccine_doses,
                                                      FUN = mean,
                                                      width = 7,
                                                      align = 'right',
                                                      fill = NA)) %>% 
  ungroup()


## plots
plot_COVID19_indicators_state_level(state = "California")
