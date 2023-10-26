# clear work space
rm(list = ls())
graphics.off()

# load libraries
library(ggplot2)
library(dplyr)
library(ggwordcloud)
library(stringr)

# Heat map
mpg %>% 
  group_by(manufacturer, class) %>% 
  summarise(cars = n()) %>% 
  ggplot(aes(x = class,
             y = manufacturer,
             fill = cars)) +
  geom_tile()

mpg %>% 
  group_by(manufacturer, class) %>% 
  summarise(`hwy mean` = mean(hwy)) %>% 
  ggplot(aes(x = manufacturer, 
             y = class,
             fill = `hwy mean`)) +
  geom_tile()

# word cloud
df.cars <- mpg %>% 
  count(model, manufacturer)

set.seed(135)
df.cars %>% 
  ggplot(aes(label = model,
             size = n)) +
  geom_text_wordcloud() +
  scale_size_area(max_size = 10) +
  theme_minimal()

## words rotation
df.cars <- df.cars %>% 
  mutate(angle = 90 * sample(c(0, 1), n(), replace = T, 
                             prob =c(0.7, 0.3))) %>%
  mutate(angle1 = 45 * sample(c(-2:2), n(), replace = T,
                              prob = c(1, 1, 4, 1, 1)))
  
df.cars %>% 
  ggplot(aes(label = model,
             size = n,
             angle = angle1,
             color = manufacturer)) +
  geom_text_wordcloud() +
  scale_size_area(max_size = 10) +
  scale_color_viridis_d(option = "A") +
  theme_minimal()

# Map

## crime map data
df.crime <- USArrests %>% 
  mutate(region = str_to_lower(rownames(.))) %>% 
  left_join(x = .,
            y = map_data("state"),
            by = "region")

## create the map
df.crime %>% 
  ggplot(aes(x = long,
             y = lat,
             group = group)) +
  geom_polygon(aes(fill = Assault),
               color = "white") +
  scale_fill_viridis_c(option = "A") +
  theme_minimal()