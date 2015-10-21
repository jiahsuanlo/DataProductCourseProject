library(shiny)



# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    # default region color
    defaultColors <- c("#3366cc", "#dc3912", "#ff9900", "#109618", "#990099", "#0099c6", "#dd4477", "#ff00ff")
    series <- structure(
        lapply(defaultColors, function(color) { list(color=color) }),
        names = levels(data$Region)
    )
    
    yearData <- reactive({
        
        # get y indicator code
        yCode<- vIndCode[vIndName==input$var]
        
        # Filter to the desired year, and put the columns
        # in the order that Google's Bubble Chart expects
        # them (name, x, y, color, size). Also sort by region
        # so that Google Charts orders and colors the regions
        # consistently.
        df <- data %>%
            filter(year == input$year,
                   (Indicator.Name==input$var)|
                       (Indicator.Code== "SH.XPD.PCAP")|
                       (Indicator.Code== "SP.POP.TOTL")) %>%
            select(Country.Name, Indicator.Code,value,Region) %>%
            arrange(Region)
        
        # spread the df
        dfs <- df %>%
            spread(Indicator.Code,value) 
        # form the final df for the google chart (name, x, y, color, size)
        colNumY<- match(yCode, names(dfs))
        dfg<- dfs %>%
            select(Country.Name, SH.XPD.PCAP, 
                   colNumY ,Region, SP.POP.TOTL)
        
    })
    
    output$chart <- reactive({
        drawData<- yearData()
        
        # set max and min
        xlim <- list(
            min = min(drawData[,2])-  1000,
            max = max(drawData[,2]) + 500
        )
        ylim <- list(
            min = min(drawData[,3]),
            max = max(drawData[,3]) + 3
        )
        
        # Return the data and options
        list(
            data = googleDataTable(drawData),
            options = list(
                title = sprintf(
                    "Health expenditure vs. %s, %s",
                    input$var,input$year),
                series = series,
                # Set axis labels and ranges
                hAxis = list(
                    title = "Health expenditure, per capita ($USD)",
                    viewWindow = xlim
                ),
                vAxis = list(
                    title = input$var,
                    viewWindow = ylim
                )
            )
        )
    })
    
})