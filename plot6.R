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


# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor 
# vehicle sources in Los Angeles County, California (fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?

library(ggplot2)

subdata <- subset(NEI, (fips == "24510" | fips == "06037" ) & type=="ON-ROAD")
plotdata <- aggregate(Emissions ~ year + fips, subdata, sum)
plotdata$name[plotdata$fips == "24510"] <- "Baltimore"
plotdata$name[plotdata$fips == "06037"] <- "LA"

png('plot6.png')

g <- ggplot(plotdata, aes(factor(year), Emissions)) +
  facet_grid(. ~ name) +
  geom_bar(stat="identity")  +
  xlab("year") +
  ylab(expression('Total PM'[2.5]*" Emissions")) +
  ggtitle('Total Emissions from motor vehicle 1999-2008')

print(g)
dev.off()

