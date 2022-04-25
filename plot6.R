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
  vn  <- gsub("\\.", "", names(scct))
  names(scct) <- vn
  
  vlist <- sqldf("SELECT SCC, EISector FROM scct WHERE EISector LIKE '%Vehicles%'")
  
  bv99 <- sqldf("SELECT SUM (e.Emissions) FROM em_data AS e INNER JOIN vlist AS v ON e.SCC = v.SCC WHERE (year = 1999 AND fips = '24510')")
  bv02 <- sqldf("SELECT SUM (e.Emissions) FROM em_data AS e INNER JOIN vlist AS v ON e.SCC = v.SCC WHERE (year = 2002 AND fips = '24510')")
  bv05 <- sqldf("SELECT SUM (e.Emissions) FROM em_data AS e INNER JOIN vlist AS v ON e.SCC = v.SCC WHERE (year = 2005 AND fips = '24510')")
  bv08 <- sqldf("SELECT SUM (e.Emissions) FROM em_data AS e INNER JOIN vlist AS v ON e.SCC = v.SCC WHERE (year = 2008 AND fips = '24510')")
  
  lav99 <- sqldf("SELECT SUM (e.Emissions) FROM em_data AS e INNER JOIN vlist AS v ON e.SCC = v.SCC WHERE (year = 1999 AND fips = '06037')")
  lav02 <- sqldf("SELECT SUM (e.Emissions) FROM em_data AS e INNER JOIN vlist AS v ON e.SCC = v.SCC WHERE (year = 2002 AND fips = '06037')")
  lav05 <- sqldf("SELECT SUM (e.Emissions) FROM em_data AS e INNER JOIN vlist AS v ON e.SCC = v.SCC WHERE (year = 2005 AND fips = '06037')")
  lav08 <- sqldf("SELECT SUM (e.Emissions) FROM em_data AS e INNER JOIN vlist AS v ON e.SCC = v.SCC WHERE (year = 2008 AND fips = '06037')")

b_v <- as.numeric(c(bv99, bv02, bv05, bv08))
l_v <- as.numeric(c(lav99, lav02, lav05, lav08))
years <- as.numeric(c(1999, 2002, 2005, 2008))
plot6 <- cbind(years, BaltimoreCity = b_v)
plot6 <- cbind(plot6, LosAngeles = l_v)
plot6 <- as.data.frame(plot6)

png(file = "plot6.png")
plot66 <- plot6 %>% gather(key, value, BaltimoreCity, LosAngeles) %>% ggplot(aes(x = years, y = value, color = key)) + 
  labs(y = "PM 2.5 from motor vehicle sources [tons]") + geom_line()
print(plot66)
dev.off()
}
