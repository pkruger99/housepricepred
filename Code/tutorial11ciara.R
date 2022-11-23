
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
lapply(c("ggplot2", "stargazer", "tidyverse", "stringr", "broom", "plot_ly", "car"),  pkgTest)

# function to save output to a file that you can read in later to your docs
output_stargazer <- function(outputFile, appendVal=FALSE, ...) {
  output <- capture.output(stargazer(...))
  cat(paste(output, collapse = "\n"), "\n", file=outputFile, append=appendVal)
}

# set working directory to current parent folder
setwd("~/housepricepred")

# data
dat <- readRDS("data/train.rds")

modpol <- lm(AdjSalePrice ~ SqFtTotLiving + I(SqFtTotLiving^2) + 
               SqFtLot + Bathrooms + Bedrooms + BldgGrade + PropertyType + 
               ZipGroup, data = dat)

stargazer(mod4, mod5, modpol, type = "text")

terms_poly <- predict(modpol, type = "terms") 
# extract the individual regression terms from our model for each observation

partial_resid_poly <- resid(modpol) + terms_poly 
# add the individual regression terms to the residual for each observation

df_poly <- data.frame(SqFtTotLiving = dat[, "SqFtTotLiving"], # create a new data.frame of these vals
                      Terms = terms_poly[, "I(SqFtTotLiving^2)"],
                      PartialResid = partial_resid_poly[, "I(SqFtTotLiving^2)"])

ggplot(df_poly, aes(SqFtTotLiving, PartialResid)) +
  geom_point(alpha = 0.2) +
  geom_smooth() +
  geom_line(aes(SqFtTotLiving, Terms), colour = "red")

## model diagnostics
par(mfrow = c(2, 2)) # we change the graphic device to show 4 plots at once
plot(modpol) # we supply our lm object to plot()

scatter.smooth(dat$SqFtTotLiving, resid(modpol), # plot a smooth line on the scatter plot
               lpars = list(col = "blue", lwd = 3, lty = 3), 
               main = "Residual Plot (Sale Price ~ Size)",
               xlab = "Total Living Area (sq.ft.)",
               ylab = "Residuals")
abline(h = 0, col = "red")

par(mfrow = c(1,1))
avPlot(modpol, variable = "SqFtTotLiving")



