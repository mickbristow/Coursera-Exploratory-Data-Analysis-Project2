#check if data dorectory exists
if(!file.exists("./data")){
  dir.create("./data")
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

#only download if not alreasy downloaded
if (!file.exists("./data/RawData.zip")){
  download.file(fileUrl,destfile="./data/RawData.zip")
}

#only unzip if not previously unzipped
if(!file.exists("./data/summarySCC_PM25.rds")){
  unzip(zipfile="./data/RawData.zip",exdir="./data")
}

## This first line will likely take a few seconds. Be patient!
if(!exists("NEI")){
  NEI <- readRDS("./data/summarySCC_PM25.rds")
  SCC <- readRDS("./data/Source_Classification_Code.rds")
}


# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
# which of these four sources have seen decreases in emissions from 1999 2008 for Baltimore City? 
# Which have seen increases in emissions from 1999 2008? 
# Use the ggplot2 plotting system to make a plot answer this question.
library(ggplot2)

#get copal categories
coalCats<-unique(grep("coal", SCC$EI.Sector, ignore.case=TRUE, value=TRUE))
#Subset SCC by coal labels
subData<-subset(SCC, EI.Sector %in% coalCats)
#Subset NEI by data1 overlaps
coalData<-subset(NEI, SCC %in% subData$SCC)  

png('plot4.png')
g <- ggplot(data=coalData, aes(x=year, y=Emissions, fill = type)) + 
  geom_bar(stat="identity", position=position_dodge()) + 
  ggtitle("Coal Combustion-Related Emissions: Year 1999-2008")

print(g)

dev.off()

