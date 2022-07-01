library(tidyverse)

plot_data = readRDS("data/plot_data.RDS")

p1 = plot_data %>%
  ggplot(aes(x=year, y=percent_poverty, fill = location)) +
  geom_line() + 
  geom_point() + 
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = 0.3) + 
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) + 
  scale_x_continuous(breaks = seq(2005, 2019, 2)) +
  scale_fill_manual(values = c("#00BA38", "#619CFF", "#F8766D")) +
  geom_vline(xintercept = 2015, linetype = "dashed") + 
  labs(y = "Poverty Rate", x = NULL, 
       title = "Poverty Rate, 2005-2019",
       subtitle = "U.S. Census Bureau ACS 1- Year Estimates") +
  annotate("text", label = "Seattle Minimum Wage", size = 3, x = 2017.3, y = 0.15) + 
  theme_bw() +
  theme(legend.title = element_blank()) 

ggsave(p1, filename = "plots/poverty_trajectories.png", width = 7, height = 5)