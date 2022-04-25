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
  
  clist <- sqldf("SELECT SCC, EISector FROM scct WHERE EISector LIKE '%Coal%'")
  
  auscr99 <- sqldf("SELECT SUM (e.Emissions) FROM em_data AS e INNER JOIN clist AS c ON e.SCC = c.SCC WHERE year = 1999")
  auscr02 <- sqldf("SELECT SUM (e.Emissions) FROM em_data AS e INNER JOIN clist AS c ON e.SCC = c.SCC WHERE year = 2002")
  auscr05 <- sqldf("SELECT SUM (e.Emissions) FROM em_data AS e INNER JOIN clist AS c ON e.SCC = c.SCC WHERE year = 2005")
  auscr08 <- sqldf("SELECT SUM (e.Emissions) FROM em_data AS e INNER JOIN clist AS c ON e.SCC = c.SCC WHERE year = 2008")
  
  us_c <- as.numeric(c(auscr99, auscr02, auscr05, auscr08))
  years <- as.numeric(c(1999, 2002, 2005, 2008))
  plot4 <- cbind(years, us_c)
  
  png(file = "plot4.png")
  par(mfrow = c(1, 1))
  plot(plot4, ylab = "total PM2.5 emission in US from coal combustion related sorces [tons]", pch = 19, col = "red")
  dev.off()
}
