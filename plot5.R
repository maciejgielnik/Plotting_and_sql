if (!file.exists("NEI_data.zip")) {
  URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(URL, destfile = "./NEI_data.zip")
  unzip("NEI_data.zip")
}

{
library(data.table)
library(sqldf)

em_data <- readRDS("summarySCC_PM25.rds")
scct  <- readRDS("Source_Classification_Code.rds")
vn  <- gsub("\\.", "", names(scct))
names(scct) <- vn

vlist <- sqldf("SELECT SCC, EISector FROM scct WHERE EISector LIKE '%Vehicles%'")

bv99 <- sqldf("SELECT SUM (e.Emissions) FROM em_data AS e INNER JOIN vlist AS v ON e.SCC = v.SCC WHERE (year = 1999 AND fips = '24510')")
bv02 <- sqldf("SELECT SUM (e.Emissions) FROM em_data AS e INNER JOIN vlist AS v ON e.SCC = v.SCC WHERE (year = 2002 AND fips = '24510')")
bv05 <- sqldf("SELECT SUM (e.Emissions) FROM em_data AS e INNER JOIN vlist AS v ON e.SCC = v.SCC WHERE (year = 2005 AND fips = '24510')")
bv08 <- sqldf("SELECT SUM (e.Emissions) FROM em_data AS e INNER JOIN vlist AS v ON e.SCC = v.SCC WHERE (year = 2008 AND fips = '24510')")

b_v <- as.numeric(c(bv99, bv02, bv05, bv08))
years <- as.numeric(c(1999, 2002, 2005, 2008))
plot5 <- cbind(years, b_v)

png(file = "plot5.png")
par(mfrow = c(1, 1))
plot(plot5, ylab = "total PM2.5 emission in Baltimore City from motor vehicle sources [tons]", pch = 19, col = "red")
dev.off()
}
