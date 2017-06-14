# Author: Group Awesome
# Taken from pages 49-50 of O'Neil and Schutt
#install.packages("plyr")
library(plyr)
setwd("C:/Users/Drew/Documents/R/Doing Data Science/Housing_Data_SI")

# http://www1.nyc.gov/site/finance/taxes/property-rolling-sales-data.page


# read csv file
si <- read.csv("C:\\Users\\Drew\\Documents\\R\\Doing Data Science\\Housing_Data_SI\\rollingsales_statenisland.csv",skip=4,header=TRUE)

## Check the data
head(si)
summary(si)
str(si) # Very handy function!
#Compactly display the internal structure of an R object.


## clean/format the data with regular expressions
## More on these later. For now, know that the
## pattern "[^[:digit:]]" refers to members of the variable name that
## start with digits. We use the gsub command to replace them with a blank space.
# We create a new variable that is a "clean' version of sale.price.
# And sale.price.n is numeric, not a factor.
si$SALE.PRICE.N <- as.numeric(gsub("[^[:digit:]]","", si$SALE.PRICE))
count(is.na(si$SALE.PRICE.N))

names(si) <- tolower(names(si)) # make all variable names lower case

## Get rid of leading digits
si$gross.sqft <- as.numeric(gsub("[^[:digit:]]","", si$gross.square.feet))
si$land.sqft <- as.numeric(gsub("[^[:digit:]]","", si$land.square.feet))
si$year.built <- as.numeric(as.character(si$year.built))

## do a bit of exploration to make sure there's not anything
## weird going on with sale prices
attach(si)
hist(sale.price.n) 
detach(si)

## keep only the actual sales

si.sale <- si[si$sale.price.n!=0,]
plot(si.sale$gross.sqft,si.sale$sale.price.n)
plot(log10(si.sale$gross.sqft),log10(si.sale$sale.price.n))

## for now, let's look at 1-, 2-, and 3-family homes
si.homes <- si.sale[which(grepl("FAMILY",si.sale$building.class.category)),]
dim(si.homes)
plot(log10(si.homes$gross.sqft),log10(si.homes$sale.price.n))
summary(si.homes[which(si.homes$sale.price.n<100000),])
""

## remove outliers that seem like they weren't actual sales
si.homes$outliers <- (log10(si.homes$sale.price.n) <=5) + 0
si.homes <- si.homes[which(si.homes$outliers==0),]
plot(log10(si.homes$gross.sqft),log10(si.homes$sale.price.n))