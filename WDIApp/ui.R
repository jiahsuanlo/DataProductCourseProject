library(shiny)
library(googleCharts)

source("global.R")

shinyUI(
    fluidPage(
        # initial google charts
        googleChartsInit(),
        
        titlePanel(h2("The World Bank World Development (Health-Related) Indicator Plots")),
        
        # ====== fluid row 1 =====
        fluidRow(
            # === column 1 ===
            shiny::column(width=12, offset= 1,
                selectInput("var",label= h4("Choose y variable to display:"),
                            choices= indicators$name, width= "80%", 
                            selected = indicators$name[1]),
               
                uiOutput("slider")
            )
        ),
        
        # ===== fluid row 2 =====
        fluidRow(
            # === column 1 ===
            shiny::column(width=8,
                   googleBubbleChart("chart",
                                  width="100%", height = "475px",
                                  # Set the default options 
                                  options = list(fontName = "Source Sans Pro",
                                      fontSize = 13,
                                      # Set axis labels and ranges
                                      hAxis = list(title = "Health expenditure, per capita ($USD)"),
                                      vAxis = list(title = indicators$name[1]),
                                      
                                      # The default padding is a little too spaced out
                                      chartArea = list(top = 50, left = 75, 
                                                       right= 75,
                                          height = "75%", width = "75%"),
                                      # Allow pan/zoom
                                      explorer = list(),
                                      # Set bubble visual props
                                      bubble = list(opacity = 0.4, stroke = "none",
                                          # Hide bubble label
                                      textStyle = list(color = "none")
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
            ), # column 1
            
            # === column 2 ===
            shiny::column(width=4,
                          h3(strong("Summary of Regional Average")),
                          tableOutput("summary")
                          )
            
        ) # fluid row 2
        
      
    )  # end of fluidPage
)  # end of shinyUI