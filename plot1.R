##Downloads and unzips data into working directory
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"        
download.file(url,"./data.zip")
unzip("./data.zip")

library(dplyr) #This script requires package "dplyr" to be installed


##reads and stores data from files into emissionData and classCode
emissionDataPath<-"./summarySCC_PM25.rds"
classCodePath<-"./Source_Classification_Code.rds"
emissionData<-readRDS(emissionDataPath)
classCode<-readRDS(classCodePath)

##groups data by year and sums up the emission data yearly
groupedData <- group_by(emissionData, year)
yearlyEmissions<-summarize(groupedData,yearlyEmissions 
                           = sum(Emissions) )




##plots yearly data using base plotting system, adds title, 
##adds a regression line, and prints it in a png file.
png(filename = "plot1.png")#opens png graphics device
plot(yearlyEmissions$year, (yearlyEmissions$yearlyEmissions)/1000000, 
     xlab = "Year", ylab = "Total Emissions (million tons)", pch = 19 )
title(main = "Yearly PM2.5 Emissions (in million tons)")
model <- lm(yearlyEmissions/1000000 ~ year, yearlyEmissions)
abline(model, lwd = 2, col = "Blue", lty = "dotted")
dev.off() ##closes graphics device