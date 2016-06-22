#### Created to load data from various sources, clean it, and upload to Socrata ####


# working Directory and packages #
setwd("c:/Users/cwendt/Documents/Socrata DB/")


library(dplyr)
library(tidyr)
library(httr) # Upload to Socrata
library(stringr)

# This pulls in the credentials you need
source("./config.R")


#### Load, Clean & Write data ####

qol <- read.csv("./Quality of Life.csv")
ci <- read.csv("./Criminal Incidents.csv")
mvc <- read.csv("./MV Citations.csv")
te <- read.csv("./Traffic Enforcement.csv")

geo <- read.csv("./GeocodedData/LibCoordinates.csv")

geoToMerge <- geo %>% 
  select(-Location, -CountOfincnum) %>% 
  subset(!duplicated(Full.Address)) # Get rid of dupes


# One function we use a lot
trim <- function (x) gsub("^\\s+|\\s+$", "", x)




#### Quality of Life ####
qol <- qol %>% 
  select(-addtl)

### Merge with Geo database ### 
## First we fix strings in the address bar ##
qol$stnum <- trim(qol$stnum)
qol$stnum <- as.character(qol$stnum)
qol$stnum <- substr(qol$stnum, 1, nchar(qol$stnum)-1) 

qol$stname1 <- trim(qol$stname1)
qol$stname2 <- trim(qol$stname2)

# Make the full address variable
qol$FullAddress <- paste(qol$stnum, " ", qol$stname1, ", Somerville,", " MA", sep="")

# Some are intersections
qol$FullAddress <- ifelse(qol$stname2 != "", paste(qol$stname1, " & ", qol$stname2, ", Somerville,", " MA", sep=""), qol$FullAddress)


## Now we have an address variable that we can merge with geo ##
qolGeo <- merge(qol, geoToMerge, by.x = "FullAddress", by.y = "Full.Address", all.x = TRUE)


# Now geocode the ones that are not done 
## TODO: geocode the ones that did not get geocoded through the merge and add them back into the main database
# qolNotGeoCoded <- qolGeo %>% filter(X == "")


## Anonymize in preperation for the upload
## TODO: think about how to anonymize the address when there are no numbers
qolForSocrata <- qolGeo %>% 
  select(-FullAddress)

# We replace the last number in the address with an X here
# returns string w/o leading or trailing whitespace
qolForSocrata$stnum <- trim(qolForSocrata$stnum)
qolForSocrata$stnum <- as.character(qolForSocrata$stnum)
qolForSocrata$stnum <- substr(qolForSocrata$stnum, 1, nchar(qolForSocrata$stnum)-1) 
# append X
qolForSocrata$stnum <- paste(qolForSocrata$stnum, "X", sep="")


## Write it locally
write.csv(qolForSocrata, "./FinalForSocrata/qolForSocrata.csv", row.names = FALSE)




#### Criminal Incidents ####
ci <- ci %>% 
  select(-classtype, -repnum)

### Merge with Geo database ### 
## First we fix strings in the address bar ##
ci$stnum <- trim(ci$stnum)
ci$stnum <- as.character(ci$stnum)
ci$stnum <- substr(ci$stnum, 1, nchar(ci$stnum)-1) 

ci$stname1 <- trim(ci$stname1)
ci$stname2 <- trim(ci$stname2)

# Make the full address variable
ci$FullAddress <- paste(ci$stnum, " ", ci$stname1, ", Somerville,", " MA", sep="")

# Some are intersections
ci$FullAddress <- ifelse(ci$stname2 != "", paste(ci$stname1, " & ", ci$stname2, ", Somerville,", " MA", sep=""), ci$FullAddress)


## Now we have an address variable that we can merge with geo ##
ciGeo <- merge(ci, geoToMerge, by.x = "FullAddress", by.y = "Full.Address", all.x = TRUE)


# Now geocode the ones that are not done 
## TODO: geocode the ones that did not get geocoded through the merge and add them back into the main database
# ciNotGeoCoded <- ciGeo %>% filter(X == "")


## Anonymize in preperation for the upload
## TODO: think about how to anonymize the address when there are no numbers
ciForSocrata <- ciGeo %>% 
  select(-FullAddress)

# We replace the last number in the address with an X here
# returns string w/o leading or trailing whitespace
ciForSocrata$stnum <- trim(ciForSocrata$stnum)
ciForSocrata$stnum <- as.character(ciForSocrata$stnum)
ciForSocrata$stnum <- substr(ciForSocrata$stnum, 1, nchar(ciForSocrata$stnum)-1) 
# append X
ciForSocrata$stnum <- paste(ciForSocrata$stnum, "X", sep="")


## Write it locally
write.csv(ciForSocrata, "./FinalForSocrata/ciForSocrata.csv", row.names = FALSE)




#### Motor Vehicle Citations ####
mvc <- mvc

### Merge with Geo database ### 
## First we fix strings in the address bar ##
mvc$stnum <- trim(mvc$stnum)
mvc$stnum <- as.character(mvc$stnum)
mvc$stnum <- substr(mvc$stnum, 1, nchar(mvc$stnum)-1) 

mvc$stname1 <- trim(mvc$stname1)
mvc$stname2 <- trim(mvc$stname2)

# Make the full address variable
mvc$FullAddress <- paste(mvc$stnum, " ", mvc$stname1, ", Somerville,", " MA", sep="")

# Some are intersections
mvc$FullAddress <- ifelse(mvc$stname2 != "", paste(mvc$stname1, " & ", mvc$stname2, ", Somerville,", " MA", sep=""), mvc$FullAddress)


## Now we have an address variable that we can merge with geo ##
mvcGeo <- merge(mvc, geoToMerge, by.x = "FullAddress", by.y = "Full.Address", all.x = TRUE)


# Now geocode the ones that are not done 
## TODO: geocode the ones that did not get geocoded through the merge and add them back into the main database
# mvcNotGeoCoded <- mvcGeo %>% filter(X == "")


## Anonymize in preperation for the upload
## TODO: think about how to anonymize the address when there are no numbers
mvcForSocrata <- mvcGeo %>% 
  select(-FullAddress)

# We replace the last number in the address with an X here
# returns string w/o leading or trailing whitespace
mvcForSocrata$stnum <- trim(mvcForSocrata$stnum)
mvcForSocrata$stnum <- as.character(mvcForSocrata$stnum)
mvcForSocrata$stnum <- substr(mvcForSocrata$stnum, 1, nchar(mvcForSocrata$stnum)-1) 
# append X
mvcForSocrata$stnum <- paste(mvcForSocrata$stnum, "X", sep="")


## Write it locally
write.csv(mvcForSocrata, "./FinalForSocrata/mvcForSocrata.csv", row.names = FALSE)




#### Traffic Enforcement ####
te <- te

### Merge with Geo database ### 
## First we fix strings in the address bar ##
te$stnum <- trim(te$stnum)
te$stnum <- as.character(te$stnum)
te$stnum <- substr(te$stnum, 1, nchar(te$stnum)-1) 

te$stname1 <- trim(te$stname1)
te$stname2 <- trim(te$stname2)

# Make the full address variable
te$FullAddress <- paste(te$stnum, " ", te$stname1, ", Somerville,", " MA", sep="")

# Some are intersections
te$FullAddress <- ifelse(te$stname2 != "", paste(te$stname1, " & ", te$stname2, ", Somerville,", " MA", sep=""), te$FullAddress)


## Now we have an address variable that we can merge with geo ##
teGeo <- merge(te, geoToMerge, by.x = "FullAddress", by.y = "Full.Address", all.x = TRUE)


# Now geocode the ones that are not done 
## TODO: geocode the ones that did not get geocoded through the merge and add them back into the main database
# teNotGeoCoded <- teGeo %>% filter(X == "")


## Anonymize in preperation for the upload
## TODO: think about how to anonymize the address when there are no numbers
teForSocrata <- teGeo %>% 
  select(-FullAddress)

# We replace the last number in the address with an X here
# returns string w/o leading or trailing whitespace
teForSocrata$stnum <- trim(teForSocrata$stnum)
teForSocrata$stnum <- as.character(teForSocrata$stnum)
teForSocrata$stnum <- substr(teForSocrata$stnum, 1, nchar(teForSocrata$stnum)-1) 
# append X
teForSocrata$stnum <- paste(teForSocrata$stnum, "X", sep="")


## Write it locally
write.csv(teForSocrata, "./FinalForSocrata/teForSocrata.csv", row.names = FALSE)




#### Upload to Scorata ####

# qol
PUT("https://data.somervillema.gov/resource/n5sm-r6zx.json",
    body = upload_file("./FinalForSocrata/qolForSocrata.csv"),
    authenticate(Socrata_username, Socrata_password), 
    add_headers("X-App-Token" = Socrata_token,
                "Content-Type" = "text/csv"))

# mvc
PUT("https://data.somervillema.gov/resource/3md9-rv67.json",
    body = upload_file("./FinalForSocrata/mvcForSocrata.csv"),
    authenticate(Socrata_username, Socrata_password), 
    add_headers("X-App-Token" = Socrata_token,
                "Content-Type" = "text/csv"))
                
# te
PUT("https://data.somervillema.gov/resource/j2bq-38ev.json",
    body = upload_file("./FinalForSocrata/teForSocrata.csv"),
    authenticate(Socrata_username, Socrata_password), 
    add_headers("X-App-Token" = Socrata_token,
                "Content-Type" = "text/csv"))

# ci
PUT("https://data.somervillema.gov/resource/4jey-jqxb.json",
    body = upload_file("./FinalForSocrata/ciForSocrata.csv"),
    authenticate(Socrata_username, Socrata_password), 
    add_headers("X-App-Token" = Socrata_token,
                "Content-Type" = "text/csv"))

