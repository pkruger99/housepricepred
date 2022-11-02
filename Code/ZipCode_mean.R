rm(list=ls())

# detach all libraries
detachAllPackages <- function() {
  basic.packages <- c("package:stats", "package:graphics", "package:grDevices", "package:utils", "package:datasets", "package:methods", "package:base")
  package.list <- search()[ifelse(unlist(gregexpr("package:", search()))==1, TRUE, FALSE)]
  package.list <- setdiff(package.list, basic.packages)
  if (length(package.list)>0)  for (package in package.list) detach(package,  character.only=TRUE)
}
detachAllPackages()

# load libraries
pkgTest <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[,  "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg,  dependencies = TRUE)
  sapply(pkg,  require,  character.only = TRUE)
}

# load necessary packages
lapply(c("ggplot2", "stargazer", "tidyverse", "stringr"),  pkgTest)

# function to save output to a file that you can read in later to your docs
output_stargazer <- function(outputFile, appendVal=TRUE, ...) {
  output <- capture.output(stargazer(...))
  cat(paste(output, collapse = "\n"), "\n", file=outputFile, append=appendVal)
}


# set working directory to current parent folder
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))



?tidyverse
browseVignettes(package = "tidyverse")

## Assign data
# The tidyverse has its own package for reading in data: readr
?readr

# readr uses a very similar format to base r functions. For example, 
# we can read in a csv file using the read_csv() function, which is 
# similar to base R's read.csv() function.

###----------------------tutorial exercises--------------------------

###----------------------tutorial exercises--------------------------
#dat <- read_csv("https://raw.githubusercontent.com/gedeck/practical-statistics-for-data-scientists/master/data/house_sales.csv")
#write_csv(dat)

dat <- read_table("data/house_sales_mod.csv",  col_names = TRUE)
dat <- dat %>% mutate(Ddate = as.Date(DocumentDate))

saveRDS(dat, "/Data/house_sales.rds")
class(dat)

dat  %>% View()

dat %>% glimpse()

dat %>% ggplot() +
  geom_point(aes(Bedrooms, AdjSalePrice, colour = PropertyType)) +
  geom_jitter(aes(Bedrooms, AdjSalePrice))

dat %>% mutate(diff = AdjSalePrice - SalePrice) %>%
  select(diff)

dat %>% ggplot(aes(SalePrice, AdjSalePrice)) +
  geom_point()
  
dat %>% mutate(area = ZipCode %/%100  ) %>%
  group_by(area) %>%
  summarise(mean = mean(AdjSalePrice)) %>%
  #glimpse()
  ggplot() +
  geom_point(aes(area, mean)) 

dat %>% 
  group_by(ZipCode) %>%
  summarise(MeanAdjSalePrice = mean(AdjSalePrice)) %>%
  #glimpse()
  ggplot() +
  geom_point(aes(ZipCode, MeanAdjSalePrice)) 

dat %>% 
  group_by(ZipCode) %>%
  summarise(MeanAdjSalePrice = mean(AdjSalePrice)) %>%
  #glimpse()
  ggplot() +
  geom_point(aes(ZipCode, MeanAdjSalePrice)) 
ggsave("../ZipCode_mean.pdf")


