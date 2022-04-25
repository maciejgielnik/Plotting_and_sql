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
  
  balt99 <- sqldf("SELECT SUM(Emissions) FROM em_data WHERE (year = 1999 AND fips = '24510')")
  balt02 <- sqldf("SELECT SUM(Emissions) FROM em_data WHERE (year = 2002 AND fips = '24510')")
  balt05 <- sqldf("SELECT SUM(Emissions) FROM em_data WHERE (year = 2005 AND fips = '24510')")
  balt08 <- sqldf("SELECT SUM(Emissions) FROM em_data WHERE (year = 2008 AND fips = '24510')")
  
  sum_balt <- as.numeric(c(balt99, balt02, balt05, balt08))
  years <- as.numeric(c(1999, 2002, 2005, 2008))
  plot2 <- cbind(years, sum_balt)
  
  png(file = "plot2.png")
  par(mfrow = c(1, 1))
  plot(plot2, ylab = "total PM2.5 emission in Baltimore City [tons]", pch = 19, col = "red")
  dev.off()
}
