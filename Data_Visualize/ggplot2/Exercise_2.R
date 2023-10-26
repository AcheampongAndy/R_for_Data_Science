# clear work space
rm(list = ls())
graphics.off()

# load libraries
library(ggplot2)
library(dplyr)
library(tibble)
library(hflights)
library(forcats)

# randomly select 10000 diamonds

set.seed(123)

df <- diamonds %>%
  # selecting 100000 diamonds
  sample_n(10000) %>% 
  # create new variable volume = x ∗ y ∗ z
  mutate(volume = x * y * z) %>% 
  # now keep only diamonds with:
  # arat < 2.5 and price < 15000 and volume < 600
  filter(carat < 2.5 & price < 15000 & volume < 600)


# use your data to create scatter plot
df %>% 
  # on x axis put ”carat”
  # on y axis put ”price”
  # size of the dots is represented with ”volume”
  # for color of the dots use diamond ”cut”
  ggplot(aes(x = carat, y = price, size = volume, color = cut)) +
  geom_jitter() +
  facet_wrap(~color, scales = "free") +
  scale_color_viridis_d() +
  xlab("Diamond weight (in carats)") +
  ylab("Diamond price (in USD)") +
  ggtitle("Diamond price by weight, volumn, cut and diamond color")

# export your final plot
ggsave("Diamonds.png", plot = last_plot(), width = 36, 
       height = 30, units = "cm")