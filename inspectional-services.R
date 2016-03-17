#### Created 3/16 by Daniel Hadley to download and upload Somerville's ISD data ####
# The FTP site was created by Julie at Citizenserve


# working Directory and packages #
setwd("c:/Users/dhadley/Documents/GitHub/2015_Citizenserve_Data/")

# This pulls in the credentials you need
source("./config.R")


library(RCurl)
library(dplyr)
library(tidyr)
library(httr) # Upload to Socrata

# dates
# We use these for the charts and for downloading the most recent data
today <- Sys.Date()
yesterday <- today - 1
fileDate <- format(yesterday, format="%m%d%Y")


#### Download Daily DATA ####

url<-paste(citizenserve_FTP, fileDate,".txt", sep="")
x <-getBinaryURL(url, userpwd = citizenserve_FTP_userpwd )


# Write it 
# http://stackoverflow.com/questions/18833031/download-rdata-and-csv-files-from-ftp-using-rcurl-or-any-other-method
writeBin(x, "./tmp/Daily_Permits.txt")


# Read it
d <- read.delim("./tmp/Daily_Permits.txt")




#### Add a couple columns ####

d$PermitTypeDetail <- ifelse(substr(d$Permit., 1, 2) == "B1", "Building",
                             ifelse(substr(d$Permit., 1, 2) == "CO", "Certificate of Occupancy",
                                    ifelse(substr(d$Permit., 1, 2) == "D1", "Demolition",
                                           ifelse(substr(d$Permit., 1, 2) == "E1", "Electrical",
                                                  ifelse(substr(d$Permit., 1, 2) == "G1", "Gas",
                                                         ifelse(substr(d$Permit., 1, 2) == "P1", "Plumbing",
                                                                ifelse(substr(d$Permit., 1, 2) == "SM", "Sheet Metal",
                                                                       ifelse(substr(d$Permit., 1, 2) == "DP", "Dumpster",
                                                                              ifelse(substr(d$Permit., 1, 2) == "DI", "Certificate of Inspection",
                                                                                     "NA")))))))))



# Write it to the local and P: drives
write.csv(d, "//fileshare1/Departments2/Somerstat Data/Inspectional_Services/data/Daily_Permits.csv")


# Remove everything else
remove(url, x)




#### Upload to Socrata ####

# Remove name column for upload to Socrata for privacy purposes
forSocrata <- d %>% select(-OwnerName)


# Write it to the local and P: drives
write.csv(forSocrata, "//fileshare1/Departments2/Somerstat Data/Inspectional_Services/data/ISD_Building_Permit_Daily_Applications_Socrata.csv", row.names = FALSE)



# Upload through Socrata API
PUT("https://data.somervillema.gov/resource/q3yh-mp87.json",
    body = upload_file("//fileshare1/Departments2/Somerstat Data/Inspectional_Services/data/ISD_Building_Permit_Daily_Applications_Socrata.csv"),
    authenticate(Socrata_username, Socrata_password), 
    add_headers("X-App-Token" = Socrata_token,
                "Content-Type" = "text/csv"))

