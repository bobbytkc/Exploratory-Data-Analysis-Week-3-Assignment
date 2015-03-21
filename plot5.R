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
##codewords and belong to Baltimore
vehIndex<-grep("[Vh]eh",classCode$Short.Name)
vehCodes<-classCode$SCC[vehIndex] #creates list of codes related to vehicles
vehSubset<-(emissionData$SCC %in% as.character(vehCodes)) #checks if codes under SCC are in list
vehData<-emissionData[vehSubset,]
vehData<-vehData[vehData$fips=="24510",] ##extracts Baltimore data

##Groups the emissions from veh by year then sums up emissions yearly
vehGroupedData<-group_by(vehData,year)
vehYearlyEmissions<-summarize(vehGroupedData, yearlyEmissions = sum(Emissions))

#plots yearly data using qplot, adds title, 
##and prints it in a png file.
png(filename = "plot5.png")#opens png graphics device
qplot(year, yearlyEmissions, data= vehYearlyEmissions, 
      geom = c("point","smooth"), method = "lm", ylab = "Vehicle Emissions (tons)" )+
        ggtitle("Vehicle PM2.5 Emissions, Baltimore City, in tons")
dev.off() ##closes graphics device
