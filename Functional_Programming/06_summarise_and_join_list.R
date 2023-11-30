# clear work space
rm(list = ls())

# load libraries
library(tidyverse)

# load string data set
load("./data/strings.RData")

## create a list
set.seed(123)

## single variables
l1 <- T
l2 <- F
s1 <- words %>% sample(1)
s2 <- words %>% sample(1)
n1 <- runif(1, 0, 1000)
n2 <- runif(1, 0, 1000)

## vector
vec.l1 <- sample(c(T,F), size = round(runif(1,1,100)), replace = T)
vec.l2 <- sample(c(T,F), size = round(runif(1,1,100)), replace = T)
vec.s1 <- words %>% sample(size = round(runif(1,1,100)), replace = T)
vec.s2 <- words %>% sample(size = round(runif(1,1,100)), replace = T)
vec.n1 <- runif(1, 0, 1000) %>% sample(size = round(runif(1,1,100)), replace = T)
vec.n2 <- runif(1, 0, 1000) %>% sample(size = round(runif(1,1,100)), replace = T)

## tables
t1 <- mpg
t2 <- diamonds %>% sample_n(size = 500)

## list
list1 <- list(a=1, b="b", vec=1:10)
lest2 <- list(vec = seq(0,10,0.05), words = words[1:10])

## one list
list <- list(l1 = l1,
             l2 = l2,
             s1 = s1,
             s2 = s2,
             n1 = n1,
             n2 = n2,
             vec.l1 = vec.l1,
             vec.l2 = vec.l2,
             vec.s1 = vec.s1,
             vec.s2 = vec.s2,
             vec.n1 = vec.n1,
             vec.n2 = vec.n2,
             t1 = t1,
             t2 = t2
)

list %>% str()

## reshuffles list
list.shuffles <- list[sample(1:length(list), size = length(list), replace = F)]

## summaries and join list

## every() and same()

every(list, is.atomic)
some(list, is.atomic)

## has_element ()
has_element(list, l1)

## detect() and detect_index ()
detect(list, is.numeric)
detect_index(list, is.numeric)

## vec_depth ()
pluck_depth(list)

## append () and prepend ()
sublist1 <- list(pluck(list, 1), pluck(list, 2))
sublist2 <- list(pluck(list, 3), pluck(list, 4))

append(sublist1, sublist2)
prepend(sublist1, sublist2)

## splice ()
splice(l1, vec.l1, list1)
