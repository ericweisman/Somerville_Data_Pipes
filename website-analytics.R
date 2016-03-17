#### Created 3/16 by Daniel Hadley to download and upload Somerville's website data ####


# working Directory: the part you change for your machine #
setwd("c:/Users/dhadley/Documents/GitHub/Somerville_Data_Pipes/")

# This pulls in the credentials you need
# Nothing from this, but make sure to copy the oauth_token when you copy the repository 

library(RGoogleAnalytics)
library(RCurl)
library(dplyr)
library(tidyr)


# Load the token object
load("oauth_token")
ValidateToken(oauth_token)


# Create a list of Query Parameters
query.list <- Init(start.date = as.character(Sys.Date()-1),
                   end.date = as.character(Sys.Date()),
                   dimensions = "ga:pageTitle",
                   metrics = "ga:sessions,ga:pageviews",
                   max.results = 1000,
                   table.id = "ga:26776898")

# Create the query object
ga.query <- QueryBuilder(query.list)
# Fire the query to the Google Analytics API
ga.df <- GetReportData(ga.query, oauth_token)




#### Top from last day #### 
# dates
today <- Sys.Date()
yesterday <- today - 1
time <- Sys.time()

ga.df$pageTitle <- gsub("| City of Somerville Website", "", ga.df$pageTitle)

write.csv(ga.df, "//fileshare1/Departments/Somerstat/Common/Data/2015_City_Web_Analytics/raw_data/LastTwentyFour.csv")


