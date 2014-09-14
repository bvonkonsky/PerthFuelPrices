
|                   |                                                        |
|:------------------|:-------------------------------------------------------|
|**Author:**        | Brian von Konsky
|**Created:**       | September 2014
|**Course:**        | Developing Data Products
|**Shiny App URL:** | https://bvonkonsky.shinyapps.io/PerthFuelPrices/   

### Summary

This application enables users to monitor fuel prices in the [Perth](http://en.wikipedia.org/wiki/Perth) Metropolitan area of [Western Australia](http://en.wikipedia.org/wiki/Western_Australia).  Widgets enable the user to specify a date range and the fuel product of interest. 

Users specify the date range and fuel product of interest in the sidebar on the lefthand side of the application. The mean daily fuel price is automatically plotted. Summary statistics and retailers selling the specified fuel product at the maximum and minimum price recorded for that period are listed.

The cost of the specified petrol product is shown in blue for the specified date range. The beginning of the fuel cycle for many products is Wednesday, with each Wednesday identified using a vertical dashed red line.

When you first load this app in your browser, loading data can initially take several seconds. Please be patient. Subsequent queries should proceed quickly.

### User Interface

The period of interest is specified by the user in the convenient Shiny [Date Range widget](http://shiny.rstudio.com/gallery/date-and-date-range.html).  The beginning and ending dates of the reporting period are specified on the lefthand and righthand side of the date range widget, respectively. Dates are entered in YYYY-MM-DD format, or specified by clicking on the desired dates in the drop down calendars. Data from 2014 are currently available in the app. Data from other years are not currently available in this app.

The user also specifies the fuel product using a Shiny [select input widget](http://shiny.rstudio.com/reference/shiny/latest/selectInput.html).  Fuel product choices are listed in the table below:

|            |                    |
|:-----------|:-------------------|
|**ULP**     | Unleaded Petrol
|**PULP**    | Premium Unleaded Petrol
|**98 RON**  | High-octane unleaded fuel (Research Octane Number 98)
|**Diesel**  | [Diesel fuel](http://en.wikipedia.org/wiki/Diesel_fuel)
|**LPG**     | [Liquid Petroleum Gas](http://en.wikipedia.org/wiki/Liquefied_petroleum_gas)


Further information about Fuel Product choices are available on the [Fuel Watch web site](http://www.fuelwatch.wa.gov.au/fuelwatch/pages/public/contentholder.jspx?key=fuelTypes.html)

### Data

Fuel prices are specified in Australian Cents per Litre, based on data reported daily to the Western Australian [Department of Commerce](http://www.commerce.wa.gov.au/) and given on their [Fuel Watch](Fuel Watch) web site.

The dataset includes daily petrol prices for Western Australian petrol stations, including stations in rural and regional areas of the state.  The data in this application were limited to the Perth metropolitan area. This was done by removing all petrol stations from the data with post codes for regional areas. These postcodes correspond to those for regional areas identified on the Australian Department of Immigration [web site]( https://www.immi.gov.au/skilled/general-skilled-migration/regional-growth.htm), and for the eco-tourist [Rottnest Island](http://en.wikipedia.org/wiki/Rottnest_Island) off of the Perth coast

### Suggested Uses
Set the date range over the course of the entire calendar year for 2014 to see overall trends for the year.


Set the date range for short periods like one month or less to identify petrol station that tend to sell at low or maximum prices.

Notice that although mean daily price for some products is lower on Wednesdays for ULP, PULP, and 98 RON, this is not the case for Diesel and LPG. Also note that mean daily price is lower on Wednesdays for ULP, PULP, and 98 RON, there are some retailers who occasionally sell at lower prices on weekends.
