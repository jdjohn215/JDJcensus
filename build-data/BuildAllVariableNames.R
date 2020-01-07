# This file creates the variable code list
library(tidyverse)
library(tidycensus)

get_acs <- function(year){
  load_variables(year, dataset = "acs5") %>%
    separate(col = "name", into = c("table", "variable"), remove = FALSE, sep = "_") %>%
    select(-variable) %>%
    mutate(year = year)
}

get_sf1 <- function(year){
  load_variables(year, "sf1") %>%
    separate(col = "name", into = c("table", "variable"), remove = FALSE, sep = 4) %>%
    select(-variable) %>%
    mutate(year = year,
           type = "sf1")
}

acs.vars <- map(2010:2018, get_acs) %>%
  bind_rows()

sf1.vars <- map(c(1990,2000,2010), get_sf1) %>%
  bind_rows()

AllVariables <- bind_rows(acs.vars, sf1.vars) %>%
  mutate(type = replace(type, is.na(type), "acs"))

usethis::use_data(AllVariables, overwrite = TRUE)
