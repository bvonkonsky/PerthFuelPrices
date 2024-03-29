
# File: ui.R
# Author: Brian von Konsky
# Course: Developing Data Products, Coursera Data Science Specialization
# Date: 13 September 2014
#

library(shiny) 
library(markdown)

# minDate and maxData are specified in globalR so they are visible in both
# ur.R and global.R .

# The initial date range will be 30 days from the minimum date in the range
startDate   <<- minDate
stopDate    <<- minDate + 30

shinyUI(fluidPage(

  # Application title
  titlePanel("Perth Metro 2014 Fuel Prices"),

  # UI to get the range of dates using January 2014 as the default.
  sidebarLayout(
    sidebarPanel(
      helpText("Enter dates from 2014 specifying the period for which you wish
               to view fuel prices."),
      dateRangeInput('dateRange',
                     label = 'Entyer dates as yyyy-mm-dd.',
                     start = startDate, end = stopDate
      ),
      
      # Enable uses to slect one of five fuel types
      selectInput("product",
                  label="Fuel Type",
                  choices=c("ULP", "PULP", "98 RON", "Diesel", "LPG"),
                  selected="ULP"
                  ),
    
     helpText("See details of specific",
              a("fuel types", href="http://www.fuelwatch.wa.gov.au/fuelwatch/pages/public/contentholder.jspx?key=fuelTypes.html"),
              ".")
     
     ),

    # Provide space on the main panel for a plot of fuel prices, and also
    # for summary information 
    
    mainPanel (
      tabsetPanel(type = "tabs", selected="Help",
                  tabPanel("Plot", plotOutput("thePlot")),
                  tabPanel("Summary", verbatimTextOutput("summary")),
                  tabPanel("Retailers", verbatimTextOutput("retailers")),
                  tabPanel("Help",  includeMarkdown("README.md"))
                  )
      )
  )
))
