
# File: server.R
# Author: Brian von Konsky
# Course: Developing Data Products, Coursera Data Science Specialization
# Date: 13 September 2014
#
# This R script is the server component of a Shiny application that processes
# data originally sourced from WA Department of Commerce Fuel Watch
# http://www.fuelwatch.wa.gov.au/fuelwatch/pages/public/historicalFileDownloadRetail.jspx
#

library(shiny) 

# A list of CSV files for months from January to September 2014

files <- c (
  "FuelWatchRetail-01-2014.csv",
  "FuelWatchRetail-02-2014.csv",
  "FuelWatchRetail-03-2014.csv",
  "FuelWatchRetail-04-2014.csv",
  "FuelWatchRetail-05-2014.csv",
  "FuelWatchRetail-06-2014.csv",
  "FuelWatchRetail-07-2014.csv",
  "FuelWatchRetail-08-2014.csv",
  "FuelWatchRetail-09-2014.csv"
)

# CSV files are stored in the following directory
directory <- "data"

# Read individual CSV files
getData <- function(filename) {
  
  # Read historical data previously downloaded from 
  # http://www.fuelwatch.wa.gov.au/fuelwatch/pages/public/historicalFileDownloadRetail.jspx
  path.data <- file.path(directory, filename)
  df <- read.csv(path.data, header=TRUE)
  
  # Drop the extraneous column
  df$X <- NULL
  
  # Exclude postcodes note in the Perth Metro area as identified at
  # https://www.immi.gov.au/skilled/general-skilled-migration/regional-growth.htm
  df <- df[!( (df$POSTCODE >= 6041 & df$POSTCODE<=6044) | 
                (df$POSTCODE >= 6083 & df$POSTCODE<=6084) |
                (df$POSTCODE >= 6121 & df$POSTCODE<=6126) | 
                (df$POSTCODE >= 6200 & df$POSTCODE<=6799) |
                (df$POSTCODE == 6161) ),]
  
  # Specify dates in Austalian format, which is dd/mm/yy
  df$PUBLISH_DATE <- as.Date(df$PUBLISH_DATE, format="%d/%m/%Y")
  
  # Get a factor variable designating the day of the week for each observation
  df$weekday      <- as.factor(weekdays (as.Date(df$PUBLISH_DATE)))
  
  # Return the data frame
  return(df)
}

# Plot the time series showing mean daily fuel prices for the date range
# and fuel product specifed as parameters
timeSeries <- function (df, date1, date2, product) {
  title <- paste("Daily Mean Perth Metro", product, "Cost From", date1, 'to', date2)
  plot(aggregate(PRODUCT_PRICE ~ PUBLISH_DATE,
                 df[df$PRODUCT_DESCRIPTION==product & 
                      df$PUBLISH_DATE >= date1 & 
                      df$PUBLISH_DATE <= date2,], mean), type="l", col="blue",
       main=title, xlab="Date", ylab="AU Cents / Litre")
  
  # Draw dashed red lines on each Wednesday in the date range
  dates <- seq(date1, date2, "days")
  wednesdays <- dates[weekdays(dates) %in% "Wednesday"]
  abline(v=wednesdays, col="red", lty=2)
}

# Truncate the dates to fall within the period covered by these files.
validateDate <- function (theDate) {
  validated <- theDate
  if (validated < minDate)
    validated <- minDate
  else if (validated > maxDate)
    validated <- maxDate
  return(validated)
}

df <- do.call(rbind, lapply(files, getData))

report <- function(label, brand, address, location, price) {
  paste(label, br)
}

shinyServer(function(input, output) {

  # Respond to input changes by plotting the indicated time series
  output$thePlot <- renderPlot({
    startDate <<- validateDate(input$dateRange[1])
    stopDate  <<- validateDate(input$dateRange[2])
    timeSeries (df, startDate, stopDate, input$product)
  })
  
  # Respond to input changfes by summarising fuel priced over the given period
  output$summary <- renderPrint({
    startDate <<- validateDate(input$dateRange[1])
    stopDate  <<- validateDate(input$dateRange[2])
    period <- df[df$PRODUCT_DESCRIPTION==product &
                   df$PUBLISH_DATE >= startDate &
                   df$PUBLISH_DATE <= stopDate,]
    summary(period$PRODUCT_PRICE)
  })
  
  # Respond to input changes by listing retailers selling fuel
  # for the maximum and minimum prices during the specified data range.
  output$retailers <- renderPrint({
    startDate <<- validateDate(input$dateRange[1])
    stopDate  <<- validateDate(input$dateRange[2])
    product   <<- input$product
    period <- df[df$PRODUCT_DESCRIPTION==product &
                    df$PUBLISH_DATE >= startDate &
                    df$PUBLISH_DATE <= stopDate,]
    
    maxPrice = max(period$PRODUCT_PRICE)
    minPrice = min(period$PRODUCT_PRICE)
    maxObs <- period[period$PRODUCT_PRICE==maxPrice,]
    minObs <- period[period$PRODUCT_PRICE==minPrice,]

    cat(paste("\nRetailers selling at maximum price of",  maxPrice))
    cat(paste("\n",maxObs$BRAND_DESCRIPTION, maxObs$ADDRESS, maxObs$LOCATION, "on", maxObs$weekday, maxObs$PUBLISH_DATE))
    cat(paste("\n\nRetailers selling at minimum price of",  minPrice))
    cat(paste("\n", minObs$BRAND_DESCRIPTION, minObs$ADDRESS, minObs$LOCATION, "on", minObs$weekday, minObs$PUBLISH_DATE))
  })
  
})
