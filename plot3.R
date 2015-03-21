##Downloads and unzips data into working directory
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"        
download.file(url,"./data.zip")
unzip("./data.zip")

library(dplyr) #This script requires package "dplyr" to be installed
library(ggplot2)

##reads and stores data from files into emissionData and classCode
emissionDataPath<-"./summarySCC_PM25.rds"
classCodePath<-"./Source_Classification_Code.rds"
emissionData<-readRDS(emissionDataPath)
classCode<-readRDS(classCodePath)


##extractcs emission data of Baltimore City,
##groups data by year and type, then sums up the emission data yearly
baltData <- emissionData[(emissionData$fips == "24510"),]
baltGroupedData <- group_by(baltData, year, type)
yearlyEmissions<-summarize(baltGroupedData,yearlyEmissions = sum(Emissions) )

##plots yearly data using qplot, adds title, 
## and prints it in a png file.
png(filename = "plot3.png", width = 960)#opens png graphics device
qplot(year, yearlyEmissions, data = yearlyEmissions, facets = .~ type, 
      ylab = "Total Emissions (tons)",geom= c("point","smooth"),method = "lm")+
        ggtitle("Yearly Emissions by type, Baltimore city, in tons")
dev.off() ##closes graphics device