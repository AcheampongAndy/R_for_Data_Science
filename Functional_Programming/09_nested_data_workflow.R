# clear workspace
rm(list = ls())

# load libraries
library(tidyverse)

## model fit
df.models <- mpg %>% 
  group_by(manufacturer) %>% 
  nest() %>% 
  mutate(model = map(.x = data,
                     .f = ~lm(hwy ~ displ + cyl,
                              data = .)))

# model coefficients for only "audi"
model <- df.models %>% 
  filter(manufacturer == "audi") %>% 
  pull(model)

## shows the coefficients
model %>% flatten() %>% names()

## extract the models coefficients
model %>% flatten() %>% pluck(coefficients) %>% enframe()

## extract model summary
model %>% map(summary) %>% map_dbl("r.squared") 

# for all manufactures all models

## function to extract coefficients
extract_coef <- function(model, id_coef){
  coefficients(model)[[id_coef]]
}

df.models <- df.models %>% 
  mutate(summary = map(.x = model, .f = summary),
         `r square` = map_dbl(.x = summary, .f = "r.squared"),
         `coef a0` = map_dbl(.x = summary, .f = extract_coef, 1),
         `coef a1` = map_dbl(.x = summary, .f = extract_coef, 2),
         `coef a2` = map_dbl(.x = summary, .f = extract_coef, 3)
         )

## closer look to models with R squared equal to 0
df.models %>% 
  filter(`r square` == 0)

df.models %>% 
  filter(`r square` == 0) %>% 
  select(manufacturer, data) %>% 
  unnest(cols = c(data)) %>% 
  ungroup() %>% 
  ggplot(aes(   x  = displ, 
                y  = hwy,
             color = as.factor(cyl))) +
  geom_point() +
  facet_wrap(. ~ manufacturer)

## take closer look to models with highest R squared
df.models %>% 
  arrange(desc(`r square`)) %>% 
  head(1) %>% 
  select(manufacturer, data) %>% 
  unnest(cols = c(data)) %>% 
  ungroup() %>% 
  ggplot(aes(x = displ, 
             y = hwy,
             color = as.factor(cyl))) +
  geom_point()