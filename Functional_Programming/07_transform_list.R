# clear work space
rm(list = ls())

# load librareis
library(tidyverse)

# load data
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

list <- list.shuffles
rm(list.shuffles)
list


# modify ()
modify(list, typeof)

modify_if(list, is.data.frame, nrow)

modify_at(list, "vec.s2", length)

# cross2 ()
cross2(letters[1:3], 1:2)

# reduce ()

list.c <- list(sample(letters, 17),
               sample(letters, 17),
               sample(letters, 17),
               sample(letters, 17))

list.n <- list(runif(n = 10),
               runif(n = 10),
               runif(n = 10),
               runif(n = 10))

## intersection of letters
reduce(list.c, intersect)

## calculate cumulative sum for numeric vectors
reduce(list.n, sum)

# accumulate ()

accumulate(list.c, intersect)
accumulate(list.n, sum)
