################
## make data alt
################

library(tidyverse)

data <- read.csv("https://raw.githubusercontent.com/gedeck/practical-statistics-for-data-scientists/master/data/house_sales.csv",
                 sep = "\t")

data <- data %>%
  mutate(Ddate = as.Date(data$DocumentDate))

saveRDS(data, "\relative_path\file.rds")

data <- readRDS("\relative_path\file.rds")
