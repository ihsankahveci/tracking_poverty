theme_map <- function(...) {
  theme_minimal() +
    theme(
      text = element_text(color = "#22211d", size = 30),
      axis.line = element_blank(),
      axis.text.x = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks = element_blank(),
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      plot.title = element_text(hjust = 0.3, face = "bold", size = 50),
      # panel.grid.minor = element_line(color = "#ebebe5", size = 0.2),
      panel.grid.major = element_line(color = "#ebebe5", size = 0.2),
      panel.grid.minor = element_blank(),
      plot.background = element_rect(fill = "#f5f5f2", color = NA), 
      panel.background = element_rect(fill = "#f5f5f2", color = NA), 
      legend.background = element_rect(fill = "#f5f5f2", color = NA),
      legend.position = "top",
      legend.key.size = unit(1, "cm"),
      legend.key.width = unit(3, "cm"),
      panel.border = element_blank(),
      ...
    )
}
