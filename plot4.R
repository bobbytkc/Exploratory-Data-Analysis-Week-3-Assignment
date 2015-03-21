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


##Looks for sources that contains the word "Coal" in classCodes,
##finds the corresponding codewords, then subsets the data that has these
##codewords
coalIndex<-grep("[Cc]oal", classCode$Short.Name)
coalCodes<-classCode$SCC[coalIndex] #creates list of codes related to coal
coalSubset<-(emissionData$SCC %in% as.character(coalCodes)) #checks if codes under SCC are in list
coalData<-emissionData[coalSubset,]

##Groups the emissions from coal by year then sums up emissions yearly
coalGroupedData<- group_by(coalData, year)
coalYearlyEmissions<-summarize(coalGroupedData, yearlyEmissions = sum(Emissions))

##plots yearly data using qplot, adds title, 
##and prints it in a png file.
png(filename = "plot4.png")#opens png graphics device
qplot(year, yearlyEmissions, data = coalYearlyEmissions, 
      geom = c("point", "smooth"), method = "lm", 
      ylab = "Yearly Emissions (tons)")+
        ggtitle("Yearly PM2.5 Emissions Due to Coal, 
                Across America, in tons")
dev.off() ##closes graphics device
