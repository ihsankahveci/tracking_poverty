# This script retrieves US census data for king county blocks, including available demographics. 
# Make sure you have activated your CENSUS API KEY before running the script. 
# setup
#here::i_am("scripts/get_block_demographics.R")
library(tidycensus)
library(tidyverse)
options(scipen=99) # turns of scientific notation

# loading the list of variables available 
vars_df =  tidycensus::load_variables(year = 2010, dataset = "sf1")
vars_list = vars_df$name
write_csv(vars_df, "data/census_variables_csv")

# counties
WA_counties = get_decennial(
    state = "WA",
    geography = "county", 
    variables = vars_list,
    summary_var = "P001001", # total population
    year = 2010,
    sumfile = "sf1")

saveRDS(WA_counties, "data/WA_counties.RDS")
cat("\nCounty files are downloaded\n")

# tracts
WA_tracts = get_decennial(
  state = "WA",
  geography = "tract", 
  variables = vars_list,
  summary_var = "P001001", # total population
  year = 2010,
  sumfile = "sf1")

saveRDS(WA_tracts, "data/WA_tracts.RDS")
cat("\nTract files are downloaded\n")

# blocks
WA_blocks = get_decennial(
  state = "WA",
  geography = "block", 
  variables = vars_list,
  summary_var = "P001001", # total population
  year = 2010,
  sumfile = "sf1")

saveRDS(WA_blocks, "data/WA_blocks.RDS")
cat("\nBlock files are downloaded\n")


