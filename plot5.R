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


# How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?
library(ggplot2)

baltdata <- subset(NEI, fips == "24510" & type=="ON-ROAD")
plotData <- aggregate(Emissions ~ year, baltdata, sum)

png('plot5.png')

g <- ggplot(plotData, aes(factor(year), Emissions)) +
  geom_bar(stat="identity") +
  xlab("year") +
  ylab(expression('Total PM'[2.5]*" Emissions")) +
  ggtitle('Total Emissions from motor vehicle Maryland from 1999 to 2008')

  print(g)
dev.off()

