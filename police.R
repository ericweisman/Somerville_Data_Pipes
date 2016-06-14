#### Created 3/16 by Daniel Hadley to download Somerville's Police data ####
# DPH worked with Chris Wendt to write the code that would pull from their ODBC and upload to Socrata
# This script just downloads that
# TODO: use their API to set up incremental instead of hitting their servers each night


# working Directory: the part you change for your machine #
setwd("c:/Users/dhadley/Documents/GitHub/Somerville_Data_Pipes/")

library(RCurl)

### I save two copies, one that is for the pipelines, which I hope people will not use

qol <- getURL(url = "https://data.somervillema.gov/api/views/n5sm-r6zx/rows.csv?accessType=DOWNLOAD", ssl.verifypeer=0L, followlocation=1L)

writeLines(qol,'//fileshare1/Departments2/Somerstat Data/Police/daily/QualityOfLife.csv')
writeLines(qol,'//fileshare1/Departments2/Somerstat Data/Police/daily/data_pipeline_dont_use/QualityOfLife.csv')



ci <- getURL(url = "https://data.somervillema.gov/api/views/4jey-jqxb/rows.csv?accessType=DOWNLOAD", ssl.verifypeer=0L, followlocation=1L)

writeLines(ci, "//fileshare1/Departments2/Somerstat Data/Police/daily/CriminalIncidents.csv")
writeLines(ci,'//fileshare1/Departments2/Somerstat Data/Police/daily/data_pipeline_dont_use/CriminalIncidents.csv')



mvc <- getURL(url = "https://data.somervillema.gov/api/views/3md9-rv67/rows.csv?accessType=DOWNLOAD", ssl.verifypeer=0L, followlocation=1L)

writeLines(mvc,'//fileshare1/Departments2/Somerstat Data/Police/daily/MotorVehicleCitations.csv')
writeLines(mvc,'//fileshare1/Departments2/Somerstat Data/Police/daily/data_pipeline_dont_use/MotorVehicleCitations.csv')



te <- getURL(url = "https://data.somervillema.gov/api/views/j2bq-38ev/rows.csv?accessType=DOWNLOAD", ssl.verifypeer=0L, followlocation=1L)

writeLines(te, "//fileshare1/Departments2/Somerstat Data/Police/daily/TrafficEnforcement.csv")
writeLines(te,'//fileshare1/Departments2/Somerstat Data/Police/daily/data_pipeline_dont_use/TrafficEnforcement.csv')



#### Now we add an output to the check_pipes file ####
check_the_pipes <- read.csv("./check-the-pipes.csv", stringsAsFactors = FALSE)

# First I am just going to add today's date to show when the script ran
check_the_pipes[which(check_the_pipes$data_set == "Police_qol"), 2] <- as.character(Sys.Date())
check_the_pipes[which(check_the_pipes$data_set == "Police_ci"), 2] <- as.character(Sys.Date())
check_the_pipes[which(check_the_pipes$data_set == "Police_mvc"), 2] <- as.character(Sys.Date())
check_the_pipes[which(check_the_pipes$data_set == "Police_te"), 2] <- as.character(Sys.Date())


# Now a simple message on each saying whether the data was downloaded or not
check_the_pipes[which(check_the_pipes$data_set == "Police_qol"), 3] <- 
  ifelse(length(qol) != 1, 
         "Error dowloading latest data from Socrata",
         "Downloaded latest data from Socrata: check for errors in uploading data to Socrata")

check_the_pipes[which(check_the_pipes$data_set == "Police_ci"), 3] <- 
  ifelse(length(ci) != 1, 
         "Error dowloading latest data from Socrata",
         "Downloaded latest data from Socrata: check for errors in uploading data to Socrata")

check_the_pipes[which(check_the_pipes$data_set == "Police_mvc"), 3] <- 
  ifelse(length(mvc) != 1, 
         "Error dowloading latest data from Socrata",
         "Downloaded latest data from Socrata: check for errors in uploading data to Socrata")

check_the_pipes[which(check_the_pipes$data_set == "Police_te"), 3] <- 
  ifelse(length(te) != 1, 
         "Error dowloading latest data from Socrata",
         "Downloaded latest data from Socrata: check for errors in uploading data to Socrata")


write.csv(check_the_pipes, "./check-the-pipes.csv", row.names = FALSE)

