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

##Looks for sources that contains the word "Veh" in classCodes,
##finds the corresponding codewords, then subsets the data that has these
##codewords and belong to Baltimore or Los Angeles.
vehIndex<-grep("[Vh]eh",classCode$Short.Name)
vehCodes<-classCode$SCC[vehIndex]
vehSubset<-(emissionData$SCC %in% as.character(vehCodes))
vehData<-emissionData[vehSubset,]
vehData<-vehData[(vehData$fips=="24510") | (vehData$fips == "06037"),]
vehData$fips<-as.factor(vehData$fips)
levels(vehData$fips)<-c("Los Angeles County", "Baltimore City") #renames the codes to their repective names


##Groups the emissions from veh by year then sums up emissions yearly
vehGroupedData<-group_by(vehData,year,fips)
vehYearlyEmissions<-summarize(vehGroupedData, yearlyEmissions = sum(Emissions))

#plots yearly data using qplot, adds title, 
##and prints it in a png file.
png(filename = "plot6.png", width = 960)#opens png graphics device
qplot(year, yearlyEmissions, data= vehYearlyEmissions, facets = .~ fips,
      geom = c("point","smooth"), method = "lm", ylab = "Vehicle Emissions (tons)" )+
        ggtitle("Vehicle PM2.5 Emissions, Los 
                Angeles Country vs Baltimore City , in tons")
dev.off() ##closes graphics device
