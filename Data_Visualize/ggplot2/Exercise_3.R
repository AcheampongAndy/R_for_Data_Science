# clear work space
rm(list = ls())
graphics.off()

# load libraries
library(ggplot2)
library(dplyr)
library(tidyr)
library(stringr)
library(forcats)
library(tibble)
library(ggwordcloud)

# load data set
corpus <- readLines("./data/corpus.txt")


## assign clean corpus to object called corpus.clean
set.seed(123)

corpus.clean <- corpus %>% 
  str_to_lower() %>% 
  str_remove_all("[:punct:]") %>% 
  str_remove_all("[:digit:]") %>% 
  str_replace_all("\\s{2,}", " ") %>% 
  str_replace_all("\t|\n"," ") %>% 
  str_trim("both")

corpus.clean %>% head()

## create a table called corpus.words
## corpus.words holds two columns: word - word from the corpus, count - frequency
corpus.words <- corpus.clean %>% 
  str_c(sep = " ", collapse = " ") %>% 
  str_split(pattern = " ") %>% 
  unlist() %>% 
  tibble(word = .) %>% 
  group_by(word) %>% 
  summarise(count = n()) %>% 
  ungroup() %>% 
  arrange(desc(count)) %>% 
  mutate(rank = row_number()) %>% 
  # filter only 200 words
  filter(rank <= 200) %>% 
  # word rotation
  mutate(angle = 45 * sample(c(-2:2), n(), 
                             replace = T, prob = c(1, 1, 4, 1, 1))) %>% 
  # create group
  mutate(first_letter = str_sub(word, 1, 1),
         group = case_when(first_letter %in% letters[1:5]   ~ "a",
                           first_letter %in% letters[6:10]  ~ "b",
                           first_letter %in% letters[11:15] ~ "c",
                           first_letter %in% letters[16:20] ~ "d",
                           first_letter %in% letters[21:26] ~ "e",
                           TRUE ~ "f"))


# now use table ”corpus.words” to draw word cloud
corpus.words %>% 
  ggplot(aes(label = word,
             size = count,
             angle = angle,
             color = group)) +
  geom_text_wordcloud() +
  scale_size_area(max_size = 30) +
  scale_color_viridis_d(option = "A") +
  theme_minimal()

# export your final plot
ggsave("wordscloud.png", plot = last_plot(),
       width = 30, height = 26, units = "cm", bg = "white")