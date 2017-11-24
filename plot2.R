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

#Have total emissions from PM2.5 decreased in the Baltimore City, 
#Maryland (fips == "24510") from 1999 to 2008? Use the base plotting 
#system to make a plot answering this question
#subset out tje Maryland data
subData <- subset(NEI, fips == "24510")
plotdata <- with(subData, aggregate(Emissions, by = list(year), sum))
#plot(plotdata, type='l', ylab='Emissions', xlab='Year')

png('plot2.png')
barplot(height = plotdata$x, names.arg= plotdata$Group.1, ylab='Emissions', xlab='Year')
dev.off()

