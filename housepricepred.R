#################################
# Tutorial 5: Data Manipulation #
#################################

## Packages
library(tidyverse) # Load our packages here
#library(broom) # If not installed - function for installing?

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

class(dat)

dat  %>% View()

dat %>% glimpse()
