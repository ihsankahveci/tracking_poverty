This project is designed the pull American Community Survey Poverty data and visualize the trajectories of poverty rate. The results are used as a descriptive content to the Seattle $15 Minimum Wage study. 

```
.
├── README.md
├── data
│   ├── WA_counties.RDS
│   ├── WA_geo_counties.RDS
│   ├── WA_geo_tracts.RDS
│   ├── WA_tracts.RDS
│   ├── WA_tracts_no_water.RDS
│   ├── census_variables.RDS
│   ├── census_variables.csv
│   ├── plot_data.RDS
│   ├── seattle_city_tracts.csv
│   └── total_data.RDS
├── main.R
├── plots
│   ├── poverty_trajectories.png
│   ├── single_hh_maps_count.pdf
│   └── single_hh_maps_percent.pdf
├── resources
│   └── decennial_2010_sf1.pdf
├── scripts
│   ├── compare_seattle_king_county.R
│   ├── create_hh_tables.R
│   ├── get_acs_poverty.R
│   ├── get_census_sf1.R
│   ├── get_shapefiles.R
│   ├── plot_poverty_trajectories.R
│   └── plot_themes.R
└── tracking_poverty .Rproj
```

To update the folder structure:
```r 
fs::dir_tree(recurse = 2, glob = "renv*", invert = TRUE)
```