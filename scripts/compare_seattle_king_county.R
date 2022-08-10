
library(sf)
library(tidyverse)
library(kableExtra)
source("scripts/plot_themes.R")
sf::sf_use_s2(FALSE) # need to turn off spherical coordinates.

# load list of census variables
# load shapefiles for WA tracts 
# load list of tracts in Seattle Municipal Area
vars = read_csv("data/census_variables.csv")
tracts = readRDS("data/WA_tracts.RDS")
# tracts_geo = readRDS("data/WA_geo_tracts.RDS")
seattle = read_csv("data/seattle_city_tracts.csv", col_types = cols(.default = col_character()))

# erase the water areas from the maps
#tracts_geo %>% erase_water() %>% saveRDS("data/WA_tracts_no_water.RDS")
tracts_no_water = readRDS("data/WA_tracts_no_water.RDS")

# select the household variables
hh_vars = vars %>% 
  filter(str_detect(name, "P0280|H0130|P001001")) %>%
  mutate(label = case_when(
    name == "P001001" ~ "Total Population",
    name == "H013001" ~ "Total Households",
    TRUE              ~ label)) %>%
  mutate(label = str_remove(label, "Total!!")) %>% 
  select(variable = name, label) %>%
  distinct(label, .keep_all = TRUE)

tracts_temp = tracts %>% 
  rename(geoid = GEOID, name = NAME, total_pop = summary_value) %>%
  filter(str_detect(name, "King County")) %>%
  inner_join(hh_vars, by = "variable")

total_hh = tracts_temp %>% 
  select(geoid, value, label) %>%
  filter(label == "Total") %>%
  pivot_wider(names_from = label, values_from = value) %>%
  rename(total_hh = Total)

tracts_hh = tracts_temp %>%
  filter(label != "Total") %>%
  mutate(seattle_flg = ifelse(geoid %in% seattle$GEOID10, 1, 0)) %>%
  left_join(total_hh, by = "geoid") %>%
  select(geoid:variable, label, value, total_hh, total_pop, seattle_flg)

# TABLE
# aggregating into king county and seattle area
king_hh = tracts_hh %>%
  group_by(label) %>%
  summarise(across(value:total_pop, ~sum(.x, na.rm = TRUE))) %>%
  mutate(king_pct = round(100*value/total_hh, 2)) %>%
  select(label, king = value, king_pct)

seattle_hh = tracts_hh %>%
  filter(seattle_flg == 1) %>%
  group_by(label) %>%
  summarise(across(value:total_pop, ~sum(.x, na.rm = TRUE))) %>%
  mutate(seattle_pct = round(100*value/total_hh, 2)) %>%
  select(label, seattle = value, seattle_pct)

# joining and re-organizing for the table
comparison_tbl = king_hh %>%
  full_join(seattle_hh, by = "label", suffix = c("_king", "_seattle")) %>% 
  mutate(across(ends_with("pct"), ~ifelse(.x > 100, NA, .x))) %>%
  slice(n(), n() - 1, 1:(n()-2))

# creating an customizable html/LaTeX table
comparison_tbl %>%
  mutate(label = str_remove(label, "Family households!!|Nonfamily households!!")) %>%
  knitr::kable(
    format = "html", 
    caption = glue::glue("Census Counts for King County and Seattle")) %>%
  kable_classic(lightable_options = "striped") %>%
  row_spec(c(2, 10, 17), bold = TRUE) %>%
  add_indent(c(3:9, 11:16, 18:24))
  

# MAPS
# a function for choropleth maps 
create_maps = function(geo_data, fill_col, percent = TRUE){
  fill_col = enquo(fill_col)
  if(percent) {
    max_n = 100
    legend_name = "Percent"}
  else {
    max_n = geo_data %>% pull(!!fill_col) %>% max(na.rm = TRUE)
    legend_name = "Count"}
    
  ##  WA tracts 
  wa_geo = geo_data %>%
    mutate(pct_single_hh = round(100*total_single_hh/total_units, 2))
  
  p1 = ggplot(data = wa_geo, aes(fill = !!fill_col)) + 
    geom_sf(color = NA) +
    scale_fill_viridis_c(option = "magma", direction = -1, limits = c(1, max_n)) +
    theme_map() +
    theme(text = element_text(color = "#22211d", size = 20))  +
    labs(title = "WA State - Single Households", 
         fill = legend_name)

  ## King County Tracts
  king_geo = wa_geo %>% filter(str_detect(NAME, "King County")) 
           
  p2 = ggplot(data = king_geo, aes(fill = !!fill_col)) + 
    geom_sf(color = NA) +
    scale_fill_viridis_c(option = "magma", direction = -1, limits = c(1, max_n)) +
    theme_map() +
    theme(text = element_text(color = "#22211d", size = 20)) +
    labs(title = "King County - Single Households", 
         fill = legend_name)

  ## Seattle City Tracts
  seattle_geo = king_geo %>% filter(GEOID %in% seattle$GEOID10)
  p3 = ggplot(data = seattle_geo, aes(fill = !!fill_col)) + 
    geom_sf(color = NA) +
    scale_fill_viridis_c(option = "magma", direction = -1, limits = c(1, max_n)) +
    theme_map() +
    theme(text = element_text(color = "#22211d", size = 20)) +
    labs(title = "Seattle City - Single Households", 
       fill = legend_name)
  
  plots = list(p1,p2,p3)
  return(plots)
}

maps = create_maps(tracts_no_water, fill_col = pct_single_hh, percent = TRUE)
pdf(file = "plots/single_hh_maps_percent.pdf", width = 14, height = 14)
maps
dev.off()

