# functions for NA detection
count_NA <- function(df){
  require(tidyverse)
  require(cowplot)
  
  # count NA
  df.NA.count <- map(df, ~sum(is.na(.))) %>% 
    simplify() %>% 
    tibble(col = names(.),
           NAs = .) %>% 
    mutate(`NA %` = round(NAs / nrow(df) * 100, 2))
  
  print(df.NA.count %>% as.data.frame())
  
  # absolute NA count
  p1 <- df.NA.count %>% 
    ggplot(aes(x = col,
               y = NAs)) +
    geom_col() +
    theme(axis.text.x = element_text(angle = 90))
  
  # relative NA count
  p2 <- df.NA.count %>% 
    ggplot(aes(x = col,
               y = `NA %`)) +
    geom_col() +
    scale_y_continuous(limits = c(0, 100)) +
    theme(axis.text.x = element_text(angle = 90))
  
  plot_grid(p1, p2, nrow = 2)
}


# b) function for time span check
check_time_span <- function(df){
  require(tidyverse)
  # summaries time span table level
  table.count <- df %>% 
    summarise(distinct_date = n_distinct(date),
              min_date = min(date),
              max_date = max(date),
              `days between max and min` = max_date - min_date)
  
  print(table.count)
  
  # show distinct dates count for each state
  df %>% 
    # count distinct dates for each states
    group_by(state) %>% 
    summarise(distinct_date = n_distinct(date)) %>% 
    ungroup() %>% 
    ggplot(aes(x = state,
               y = distinct_date)) +
    geom_col() +
    theme(axis.text.x = element_text(angle = 90))
}


# 3) Data Wrangling
## a) states name matching

state_matching <- function(state_base = states.list,
                           data,
                           col_name){
  require(tidystringdist)
  require(rlang)
  require(tidyverse)
  
  # name of finale state column
  col_name = rlang::ensym(col_name)
  
  # extract unique state names from given data
  states.data <- data %>% distinct(state)
  
  # create table of all combinations state pairs
  states.combs <- expand.grid(state_base = states.list %>% pull(state_base),
                              state = states.data %>% pull(state))
  
  # compute string distance
  states.distance <- tidy_stringdist(df = states.combs,
                  v1 = state_base,
                  v2 = state, method = 'osa') %>% 
  # sort best name match per state_base & add matching rank
    arrange(state_base, osa) %>% 
    group_by(state_base) %>% 
    mutate(rank = row_number()) %>% 
    ungroup() %>% 
    # filter only top ranks
    filter(rank == 1) %>% 
    select(state_base, !!col_name := state)
  
  return(states.distance)
}


# 4) EDA
## a) plot function: confirmed cases / deaths total count over time
plot_confirmed_cases_total <- function(region.group){
  # data
  plot.data <- df.main %>% 
    filter(`region - group` == region.group)
  
  # confirmed cases absolute count
  p11 <- plot.data %>% 
    ggplot(aes(x = date,
               y = `confirmed total`,
               group = state,
               color = state)) +
    geom_line(show.legend = F) +
    geom_point(show.legend = F) +
    scale_color_viridis_d() +
    xlab('Date') +
    ylab('Num of confirmed cases total') +
    ggtitle(paste0('Infected cases / ', region.group)) 
    #theme_minimal()
  
  
  # confirmed cases relative count
  p21 <- plot.data %>% 
    ggplot(aes(x = date,
               y = `confirmed total %`,
               group = state,
               color = state)) +
    geom_line(show.legend = F) +
    geom_point(show.legend = F) +
    scale_color_viridis_d() +
    xlab('Date') +
    ylab('% of confirmed cases total') 
    #theme_minimal()
  
  
  # deaths absolute count
  p12 <- plot.data %>% 
    ggplot(aes(x = date,
               y = `deaths total`,
               group = state,
               color = state)) +
    geom_line() +
    geom_point() +
    scale_color_viridis_d() +
    xlab('Date') +
    ylab('Num of deaths total') +
    ggtitle(paste0('Deaths cases / ', region.group)) 
    #theme_minimal()
  
  
  # deaths relative count
  p22 <- plot.data %>% 
    ggplot(aes(x = date,
               y = `deaths total %`,
               group = state,
               color = state)) +
    geom_line() +
    geom_point() +
    scale_color_viridis_d() +
    xlab('Date') +
    ylab('% of deaths total') 
    #theme_minimal()
  
  # subplots
  plot <- plot_grid(p11, p12, p21, p22, nrow = 2, ncol = 2)
  
  # plot export
  ggsave(filename = paste0('./explore/01_confirmed_cases_deaths', region.group, '.png'),
         plot = plot,
         width = 30,
         height = 20, 
         units = 'cm')
}


# b) plot function: confirmed daily cases and deaths 7day avg
plot_confirmed_deaths_cases_7d_avg <- function(region.group){
  # data
  plot.data <- df.main %>% 
    filter(`region - group` == region.group)
  
  # confirmed
  p1 <- plot.data %>% 
    ggplot(aes(x = date,
               y = `confirmed daily cases 7day avg`,
               group = state,
               color = state)) +
    geom_line(show.legend = T,
              size = 0.9) +
    geom_point(show.legend = F,
               size = 1) +
    scale_color_viridis_d() +
    xlab('Date') +
    ylab('Number of cases (7 day avg)') +
    ggtitle(paste0('Infected daily cases /', region.group))
  
  
  # deaths
  p2 <- plot.data %>% 
    ggplot(aes(x = date,
               y = `death cases 7day avg`,
               group = state,
               color = state)) +
    geom_line(show.legend = T,
              size = 0.9) +
    geom_point(show.legend = F,
               size = 1) +
    scale_color_viridis_d() +
    xlab('Date') +
    ylab('Number of deaths (7 day avg)') +
    ggtitle(paste0('Deaths /', region.group))
  
  # subplots
  plot <- plot_grid(p1, p2, nrow = 2)
  
  # plot export
  ggsave(filename = paste0('./explore/03_confirmed_cases_deaths_7day_avg', region.group, '.png'),
         plot = plot,
         width = 30,
         height = 20, 
         units = 'cm', dpi = 600)
    
}


# c) plot function: confirmed daily cases and deaths 7day avg + total vaccine doses
plot_confirmed_deaths_cases_7d_avg_vaccine_doses_total <- function(region.group){
  # data
  plot.data <- df.main %>% 
    filter(`region - group` == region.group)
  
  # confirmed
  p1 <- plot.data %>% 
    ggplot(aes(x = date,
               y = `confirmed daily cases 7day avg`,
               group = state,
               color = state)) +
    geom_line(show.legend = T,
              size = 0.9) +
    geom_point(show.legend = F,
               size = 1) +
    scale_color_viridis_d() +
    xlab('Date') +
    ylab('Number of cases (7 day avg)') +
    ggtitle(paste0('Infected daily cases /', region.group))
  
  
  # deaths
  p2 <- plot.data %>% 
    ggplot(aes(x = date,
               y = `death cases 7day avg`,
               group = state,
               color = state)) +
    geom_line(show.legend = T,
              size = 0.9) +
    geom_point(show.legend = F,
               size = 1) +
    scale_color_viridis_d() +
    xlab('Date') +
    ylab('Number of deaths (7 day avg)') +
    ggtitle(paste0('Deaths /', region.group))
  
  # total vaccine doses
  p3 <- plot.data %>% 
    ggplot(aes(x = date,
               y = vaccine_doses_total,
               group = state,
               color = state)) +
    geom_line(show.legend = T,
              size = 0.9) +
    geom_point(show.legend = F,
               size = 1) +
    scale_color_viridis_d() +
    xlab('Date') +
    ylab('Total vaccine doses') +
    ggtitle(paste0('Total vaccine doses /', region.group))
  
  # subplots
  plot <- plot_grid(p1, p2, p3, nrow = 3)
  
  # plot export
  ggsave(filename = paste0('./explore/05_confirmed_cases_deaths_7day_avg_tot_vacc_doses', region.group, '.png'),
         plot = plot,
         width = 30,
         height = 20, 
         units = 'cm', dpi = 600)
  
}

## d) plot function: selected state indicators
plot_COVID19_indicators_state_level <- function(state_selection){
  # data
  df.main.state <- df.main %>% filter(state == state_selection)
  
  ## total count
  p1 <- df.main.state %>% 
    select(date, `confirmed total`, `deaths total`, vaccine_doses_total) %>% 
    pivot_longer(cols = c("confirmed total", "deaths total", "vaccine_doses_total"),
                 names_to = "indicator", values_to = "value") %>% 
    mutate(indicators = factor(indicator, 
                               levels = c("vaccine_doses_total", "confirmed total", "deaths total"))) %>% 
    ggplot(aes(x = date, 
               y  = value, 
               fill = indicator)) +
    geom_area(color = "black") +
    scale_fill_manual(values = c("forestgreen", "brown1", "black")) +
    xlab("Date") +
    ylab("Total counts") +
    ggtitle(paste0("State: ", state_selection, "- COVID 19 indicators over observed time")) +
    theme_minimal()
  
  ## total count
  p2 <- df.main.state %>% 
    select(date, `confirmed daily cases 7day avg`, `death cases 7day avg`, `daily vaccine dosses 7day avg`) %>% 
    pivot_longer(cols = c("confirmed daily cases 7day avg", "death cases 7day avg", 
                          "daily vaccine dosses 7day avg"),
                 names_to = "indicator", values_to = "value") %>% 
    mutate(value = na_if(value, 0)) %>% 
    ggplot(aes(x = date, 
               y  = value, 
               group = indicator, 
               color = indicator)) +
    geom_line(size = .9) +
    geom_point(size = 1.2) +
    scale_y_log10() +
    scale_color_manual(values = c("brown1", "forestgreen",  "black")) +
    xlab("Date") +
    ylab("7day averages indicators") +
    theme_minimal()
  
  ## total count
  p3 <- df.main.state %>% 
    select(date, 
           government_response_index_for_display,
           containment_health_index_for_display,
           economic_support_index_for_display,
           stringency_legacy_index_for_display) %>% 
    pivot_longer(cols = c("government_response_index_for_display",
                          "containment_health_index_for_display",
                          "economic_support_index_for_display",
                          "stringency_legacy_index_for_display"), 
                 names_to = "index", values_to = "value") %>% 
    ggplot(aes(x = date, 
               y  = value, 
               fill = index)) +
    geom_area(color = "black") +
    scale_y_continuous(limits = c(0, 300)) +
    xlab("Date") +
    ylab("State response") +
    theme_minimal()
  
  # Create subplots
  row1 <- cowplot::plot_grid(p1, NULL, rel_widths = c(0.945,0.055))
  row2 <- cowplot::plot_grid(p2, NULL, rel_widths = c(0.97,0.03))
  row3 <- cowplot::plot_grid(p3, NULL, rel_widths = c(1,0))
  plot_ <- cowplot::plot_grid(row1, row2, row3, nrow = 3)
  
  # export plot
  ggsave(filename = paste0("./explore/09_COVID19_indicators_state", state_selection, ".png"),
         plot = plot_, 
         width = 35, height = 25, units = "cm", 
         dpi = 600)
}

