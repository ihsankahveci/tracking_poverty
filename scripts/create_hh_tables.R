library(tidyverse)
library(kableExtra)

# provide the desired geographic units geoid"
MY_GEOID = "53025011402"

vars = read_csv("data/census_variables.csv")
tracts = readRDS("data/WA_tracts.RDS") 

hh_vars = vars %>% 
  filter(str_detect(name, "P0280|H0130")) %>%
  mutate(label = str_remove(label, "Total!!")) %>% 
  select(variable = name, label) %>%
  distinct(label, .keep_all = TRUE)
  
tracts_temp = tracts %>% 
  rename(geoid = GEOID, name = NAME, total_pop = summary_value) %>%
  inner_join(hh_vars, by = "variable")

total_hh = tracts_temp %>% 
  select(geoid, value, label) %>%
  filter(label == "Total") %>%
  pivot_wider(names_from = label, values_from = value) %>%
  rename(total_hh = Total)

tracts_hh = tracts_temp %>%
  filter(label != "Total") %>%
  left_join(total_hh, by = "geoid") %>%
  select(geoid:variable, label, value, total_hh, total_pop)


# create a pretty table
tracts_hh %>%
  filter(geoid == MY_GEOID) %>%
  select(label, count = value, total_hh, total_pop) %>%
  mutate(percent = round(count/total_hh*100, 2), .after = count) %>%
  knitr::kable(caption = glue::glue("Household Counts from Census geoid: {MY_GEOID},
                                    Total Households: {.$total_hh[1]},
                                    Total Population: {.$total_pop[1]}")) %>%
  kable_classic() %>%
  kableExtra::remove_column(c(4,5))
  






