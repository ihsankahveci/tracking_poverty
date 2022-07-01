library(tidycensus)
library(tidyverse)

years = 2005:2019

# Grab total and poverty populations
wa <- map_df(years, function(x) {
  get_acs(geography = "state", 
          state = "WA",
          variables = "B17001_002",
          summary_var = "B01003_001",
          year = x, survey = "acs1") %>%
    mutate(year = x)
})

us <- map_df(years, function(x) {
  get_acs(geography = "us", 
          variables = "B17001_002",
          summary_var = "B01003_001",
          year = x, survey = "acs1") %>%
    mutate(year = x)
})

king <- map_df(years, function(x) {
  get_acs(geography = "county", 
          state = "WA", 
          county = "King", 
          variables = "B17001_002",
          summary_var = "B01003_001",
          year = x, survey = "acs1") %>%
    mutate(year = x)
})


# Merge US, WA, and King County data, then calculate poverty rates. 
total_data <- 
  map_df(list(us, wa, king), bind_rows) %>%
  select(name = NAME, year, total_poverty = estimate, moe, total_population = summary_est) %>%
  mutate(percent_poverty = total_poverty / total_population,
         upper = (total_poverty + moe) / total_population,
         lower = (total_poverty - moe) / total_population)

saveRDS(total_data, "data/total_data.RDS")

# preparing the data for plotting 
plot_data = total_data %>% 
  mutate(location = as_factor(case_when(
    name == "Washington" ~ "Washington State",
    name == "King County, Washington" ~ "King County", 
    TRUE ~ "U.S. Average"))) %>%
  group_by(location, year) %>%
  summarise(percent_poverty = mean(percent_poverty),
            upper = mean(upper),
            lower = mean(lower)) %>%
  ungroup()

saveRDS(plot_data, "data/plot_data.RDS")


    

