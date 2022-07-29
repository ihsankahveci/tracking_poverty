library(tidycensus)
library(tigris)
library(tidyverse)
options(scipen=99) # turns of scientific notation

geo_vars = c( 
  total_hh_size = "H013001", 
  avg_hh_size = "P017001",
  total_single_hh = "H013002",
  total_units = "H001001",
  total_pop = "P001001")

# counties
WA_geo_counties = get_decennial(
  state = "WA",
  geography = "county", 
  variables = geo_vars,
  output = "wide",
  year = 2010,
  geometry = TRUE,
  sumfile = "sf1")

saveRDS(WA_geo_counties, "data/WA_geo_counties.RDS")
cat("\nCounty shapefiles are downloaded\n")

# tracts
WA_geo_tracts = get_decennial(
  state = "WA",
  geography = "tract", 
  variables = geo_vars,
  output = "wide",
  year = 2010,
  geometry = TRUE,
  sumfile = "sf1")

saveRDS(WA_geo_tracts, "data/WA_geo_tracts.RDS")
cat("\nTract shapefiles are downloaded\n")

# blocks
WA_geo_blocks = get_decennial(
  state = "WA",
  geography = "block", 
  variables = geo_vars,
  output = "wide",
  year = 2010,
  geometry = TRUE,
  sumfile = "sf1")

saveRDS(WA_geo_blocks, "data/WA_geo_blocks.RDS")
cat("\nBlock shapefiles are downloaded\n")

