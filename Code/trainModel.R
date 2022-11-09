#trainModel.R


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
lapply(c("ggplot2", "stargazer", "tidyverse", "stringr", "broom"),  pkgTest)

# function to save output to a file that you can read in later to your docs
output_stargazer <- function(outputFile, appendVal=TRUE, ...) {
  output <- capture.output(stargazer(...))
  cat(paste(output, collapse = "\n"), "\n", file=outputFile, append=appendVal)
}


# set working directory to current parent folder
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


###########################################


dat <- readRDS("../Data/train.rds")
View(dat)

mod1 <- lm(AdjSalePrice ~ Bathrooms, data = dat)

summary(mod1)

boxplot(AdjSalePrice ~ Bathrooms, data = dat)

output_stargazer("../Results/Bathrooms_BldgGrade.tex", appendVal = FALSE, mod1,
                 title="Adjusted Sale Price, Building Grade and Bathrooms",
                 label="tab:bathrooms_bldGrade",  digits = 6
)


ggplot(dat, aes(AdjSalePrice, Bathrooms, group = BldgGrade)) +
  geom_point(alpha = 0.5, aes(colour = BldgGrade)) +
  geom_smooth(method = "lm", aes(colour = BldgGrade))

# separate out effect of gender
# additive model
mod2 <- lm(AdjSalePrice ~ Bathrooms + BldgGrade, data = dat)

dat_add <- augment(mod2)
#stargazer::stargazer(mod1, mod2, type = "html", title = "Salary and Grants, Gender")
summary(mod2)

ggplot(dat, aes(AdjSalePrice, Bathrooms, group = BldgGrade)) +
  geom_point(alpha = 0.5, aes(colour = BldgGrade)) +
  geom_line(data = dat_add, aes(y = .fitted, colour = BldgGrade)) # we change our data to the fitted values of the additive model

output_stargazer("../Results/Bathrooms_BldgGrade.tex", appendVal = FALSE, mod2,
                 title="Adjusted Sale Price, Building Grade and Bathrooms",
                 label="tab:bathrooms_bldGrade",  digits = 6
)


mod2 <- lm(AdjSalePrice ~ BldgGrade + SqFtTotLiving, data = dat)
summary(mod2)

dat %>% ggplot( aes(AdjSalePrice, SqFtTotLiving, group = BldgGrade)) +
  geom_point(alpha = 0.5, aes(colour = BldgGrade)) +
  geom_line(data = dat_add, aes(y = .fitted, colour = BldgGrade)) # we change our data to the fitted values of the additive model
ggsave("../Results/sqftLiving.png")

output_stargazer("../Results/TotLiving_BldgGrade.tex", appendVal = FALSE, mod2,
                 title="Adjusted Sale Price, Living Space and Building Grade",
                 label="tab:SqFtTotLiving_bldGrade",  digits = 6
)

