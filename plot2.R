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

##extractcs emission data of Baltimore City,
##groups data by year and sums up the emission data yearly
baltData <- emissionData[(emissionData$fips == "24510"),]
baltGroupedData <- group_by(baltData, year)
baltYearlyEmissions <- summarize(baltGroupedData, yearlyEmissions = sum(Emissions))


##plots yearly data using base plotting system, adds title, 
##adds a regression line, and prints it in a png file.
png(filename = "plot2.png")#opens png graphics device
plot(baltYearlyEmissions$year, baltYearlyEmissions$yearlyEmissions, 
     pch = 19, xlab = "Year", ylab = "Total Emissions (tons)" )
title(main="Yearly PM2.5 Emissions in Baltimore City (in tons)")
model<- lm(yearlyEmissions ~ year , baltYearlyEmissions)
abline(model, , lwd = 1, lty = "dotted", col = "Blue")
dev.off() ##closes graphics device
