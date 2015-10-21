library(shiny)
library(googleCharts)

source("global.R")

shinyUI(
    fluidPage(
        # initial google charts
        googleChartsInit(),
        
        titlePanel(h2("WHO Indicator Plots")),
        sidebarLayout(
             sidebarPanel(
                 
                selectInput("var",label= h4("Choose y variable to display:"),
                            choices= vIndName, 
                            selected = vIndName[1]),
               
                sliderInput("year",
                            label= h4("Year of interest:"),
                            min= as.integer(minYear), max= as.integer(maxYear), 
                            value= 2000,step=1,
                            animate= TRUE)
            ),
            
           
            
            mainPanel ( 
                googleBubbleChart("chart",
                                  width="100%", height = "475px",
                                  # Set the default options for this chart; they can be
                                  # overridden in server.R on a per-update basis. See
                                  # https://developers.google.com/chart/interactive/docs/gallery/bubblechart
                                  # for option documentation.
                                  options = list(
                                      fontName = "Source Sans Pro",
                                      fontSize = 13,
                                      # Set axis labels and ranges
                                      hAxis = list(
                                          title = "Health expenditure, per capita ($USD)"
                                          #viewWindow = xlim
                                      ),
                                      vAxis = list(
                                          title = vIndName[1]
                                          #viewWindow = ylim
                                      ),
                                      # The default padding is a little too spaced out
                                      chartArea = list(
                                          top = 50, left = 75,
                                          height = "75%", width = "75%"
                                      ),
                                      # Allow pan/zoom
                                      explorer = list(),
                                      # Set bubble visual props
                                      bubble = list(
                                          opacity = 0.4, stroke = "none",
                                          # Hide bubble label
                                          textStyle = list(
                                              color = "none"
                                          )
                                      ),
                                      # Set fonts
                                      titleTextStyle = list(
                                          fontSize = 16
                                      ),
                                      tooltip = list(
                                          textStyle = list(
                                              fontSize = 12
                                          )
                                      )
                                  )
                )  # google bubble chart
            ) # main panel
        ) # sidebar layout
     
        
        
        
           
    )  # end of fluidPage
)  # end of shinyUI