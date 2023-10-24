# clear work space
rm(list = ls())
graphics.off()

# load libraries
library(ggplot2)
library(dplyr)
library(tibble)
library(forcats)

# some data
groups <- paste("group", 1:4, sep = " ")
probs <- c(.2, .3, .4, .1)

set.seed(123)
df.data <- sample(groups, 1000, T, probs) %>% 
  tibble(groups = .)

## bar plot
df.data %>% 
  ggplot(aes(x = groups)) +
  geom_bar()

## bar plot stat = identity
df.data %>% 
  group_by(groups) %>% 
  summarise(freq = n()) %>% 
  ggplot(aes(x = groups,
             y = freq)) +
  geom_bar(stat = "identity")

## fill colors
df.data %>% 
  ggplot(aes(x = groups,
             fill = groups)) +
  geom_bar()

## alter fill color scalling

## a) mannuel colors
df.data %>% 
  ggplot(aes(x = groups,
             fill = groups)) +
  geom_bar(color = "black") +
  scale_fill_manual(values = c("red", "green", "gray", "yellow"))

## b) brewer - palattes
df.data %>% 
  ggplot(aes(x = groups,
             fill = groups)) +
  geom_bar(color = "black") +
  scale_fill_brewer(palette = 1)

## c) viridis - palette
df.data %>% 
  ggplot(aes(x = groups,
             fill = groups)) +
  geom_bar(color = "black") +
  scale_fill_viridis_d(option = "A")

## add lables on top of each column
df.data %>% 
  group_by(groups) %>% 
  summarise(freq = n()) %>% 
  ggplot(aes(x = groups,
             y = freq,
             fill = groups)) +
  geom_bar(stat = "identity") +
  scale_fill_viridis_d(option = "A") +
  # lables on top of each column
  geom_text(aes(label = freq,
                y = freq + 10))

## car data set
figure <- mpg %>% 
  group_by(manufacturer) %>% 
  summarise(n = n()) %>% 
  ungroup() %>% 
  mutate(percent = round(n / sum(n) * 100, 1),
         percent = paste(percent, "%", sep = "")) %>% 
  arrange(desc(n)) %>%
  # ad manufacturer as factor
  mutate(manufacturer = as_factor(manufacturer),
         manufacturer = fct_inorder(manufacturer)) %>%
  # plot
  ggplot(aes(x = manufacturer,
             y = n,
             fill = manufacturer)) +
  geom_bar(stat = "identity") +
  # add lables
  geom_text(aes(label = percent,
                y = n + 0.5),
            size = 3) +
  # add color scale
  scale_fill_viridis_d(option = "B",
                       direction = -1) +
  xlab("Car manufacturer") +
  ylab("Car count") +
  ggtitle("Number of Car per each manufacturer")

ggsave("manufacturer.png", plot = figure, units = "cm",
       width = 26, height = 21)