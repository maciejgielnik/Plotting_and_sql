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
  
  sum99 <- sqldf("SELECT SUM(Emissions) FROM em_data WHERE year = 1999")
  sum02 <- sqldf("SELECT SUM(Emissions) FROM em_data WHERE year = 2002")
  sum05 <- sqldf("SELECT SUM(Emissions) FROM em_data WHERE year = 2005")
  sum08 <- sqldf("SELECT SUM(Emissions) FROM em_data WHERE year = 2008")
  
  sum_years <- as.numeric(c(sum99, sum02, sum05, sum08))
  years <- as.numeric(c(1999, 2002, 2005, 2008))
  plot1 <- cbind(years, sum_years)
  
  png(file = "plot1.png")
  par(mfrow = c(1, 1))
  plot(plot1, ylab = "total PM2.5 emission [tons]", pch = 19, col = "red")
  dev.off()
}
