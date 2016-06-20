# Somerville_Data_Pipes
The R scripts that access data from various APIs and FTP sites, including 311, ISD, etc., and upload it to our servers/ Socrata 


# How To
There is a separate R script for each dataset. The basic idea is to use existing R packages to access data through either an API or FTP site, clean it, and then upload it to our Socrata site.

### APIs
311 is a classic, but complicated, example of how to use R to access an API. There is an API endpoint, which is essentially a URL with dates and parameters of the data that we want. 

api <- "https://somervillema.qscend.com/qalert/api/v1/requests/changes/?since=5%2F28%2F2016&key=[Qsend_API_key]"

Parsing this, you can see it is requesting the changes to our requests data since 5/28/2016. It ends with our API key. Most APIs are intuitive in this way. 

This is what comes next:

d <- fromJSON(api)

Basically, this returns a large JSON object, which I call "d", from which we can extract all of our data. Most of the rest of the 311 script is there to clean and merge data with previous records. Finally, it gets uploaded to Socrata, which I describe below. 

### FTP
CitizenServe did not have an API, so they offered to put the data on an FTP site. You can easily use the credentials to access this from a program like FileZilla, but I used R in order to automate the access. There are two basic lines in this case:

url <- paste(citizenserve_FTP, fileDate,".txt", sep="")
x <- getBinaryURL(url, userpwd = citizenserve_FTP_userpwd )    

The first one constructs the URL, which sort of functions like an API call the way they have the data set up. The next one downloads it with our credentials. These inputs will all change based on the FTP site. The nice thing is that it is super easy for them to set up, and for us to download. 

### Socrata
To upload data, I use the Socrata SODA API by way of an R package called httr. This makes it simple to do a PUT request, which as the name implies, puts data where you tell it to. 


## How to automate 
1. In Windows task scheduler, I create a new task that runs daily with highest privilges
2. The "Actions" is "start a program," which points to the .bat file in this directory
3. The .bat file runs the .R scripts, which uploads the data to our web server through FTP

## How to transfer to another machine
1. Use github to get the latest version, which should be current on the official Somerville account
2. Change the file paths in all R scripts and .bat files to reflect your desktop environment
3. Copy the config.R and oauth_token files from the current maintainer (these are not commited in Github)
4. Install all of the R packages listed in each script
5. Follow the instruction above to automate 
6. Profit 