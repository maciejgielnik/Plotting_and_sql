if (!file.exists("NEI_data.zip")) {
  URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(URL, destfile = "./NEI_data.zip")
  unzip("NEI_data.zip")
}

{
library(data.table)
library(sqldf)
library(ggplot2)
library(tidyr)

em_data <- readRDS("summarySCC_PM25.rds")
scct  <- readRDS("Source_Classification_Code.rds")

balt99e <- sqldf("SELECT Emissions, type FROM em_data WHERE (year = 1999 AND fips = '24510')")
balt02e <- sqldf("SELECT Emissions, type FROM em_data WHERE (year = 2002 AND fips = '24510')")
balt05e <- sqldf("SELECT Emissions, type FROM em_data WHERE (year = 2005 AND fips = '24510')")
balt08e <- sqldf("SELECT Emissions, type FROM em_data WHERE (year = 2008 AND fips = '24510')")

b99tp <- with(balt99e, tapply(Emissions, type, sum, na.rm = TRUE))
b02tp <- with(balt02e, tapply(Emissions, type, sum, na.rm = TRUE))
b05tp <- with(balt05e, tapply(Emissions, type, sum, na.rm = TRUE))
b08tp <- with(balt08e, tapply(Emissions, type, sum, na.rm = TRUE))

bp <- rbind(b99tp,b02tp )
bp <- rbind(bp,b05tp )
bp <- rbind(bp,b08tp )
years <- as.numeric(c(1999, 2002, 2005, 2008))
bpy <- cbind(years, bp)
bpy <- as.data.frame(bpy)
names(bpy) <- make.names(names(bpy))

png(file = "plot3.png")
plot3 <- bpy %>% gather(key, value, NONPOINT, NON.ROAD, ON.ROAD, POINT) %>% ggplot(aes(x = years, y = value, color = key)) +
  labs(y = "PM 2.5 in Baltimore City [tons]") + geom_line()
print(plot3)
dev.off()
}




