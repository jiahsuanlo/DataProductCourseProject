library(shiny)
library(lazyeval)
library(googleCharts)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    # default region color
    defaultColors <- c("#3366cc", "#dc3912", "#ff9900", "#109618", "#990099", "#0099c6", "#dd4477", "#ff00ff")
    series <- structure(
        lapply(defaultColors, function(color) { list(color=color) }),
        names = levels(data$Region)
    )
    
    # === calculate min and max year based on the data availability ===
    # get y indicator code
    yearRange<- reactive({
        # get selected y var
        yCode<- indicators$code[indicators$name==input$var]
        yName<- input$var
        colNumY<- match(yCode, names(data))
        
        iExist<- (!is.na(data[,colNumY])) & (!is.na(data$SH.XPD.PCAP))
        allyear<- data$year[iExist]
        minYear<- min(allyear)
        maxYear<- max(allyear)
        return(c(minYear,maxYear))
    })
    
    # === update slider info ===
    
    output$slider<- renderUI({
        sliderInput("year",
                label= h4("Year of interest:"),
                min= yearRange()[1], max= yearRange()[2], 
                value= yearRange()[1],step=1, width="80%",
                animate= TRUE)
    })
    
    # === construct google chart data === 
    
    yearData <- reactive({
        # Filter to the desired year and desired variables
        # and put the columns in the order that Google's Bubble
        # Chart needs (name, x, y, color, size). Also sort by region
        # so that Google Charts orders and colors the regions
        # consistently.
        
        # get selected y var
        yCode<- indicators$code[indicators$name==input$var]
        yName<- input$var
        colNumY<- match(yCode, names(data))
        
        if (!is.null(input$year))
        {
            df <- data %>%
                filter(year == input$year) %>%
                select(Country.Name,SH.XPD.PCAP,colNumY,Region,SP.POP.TOTL) %>%
                arrange(Region)
        }
        else
        {
            df <- data %>%
                filter(year == yearRange()[1]) %>%
                select(Country.Name,SH.XPD.PCAP,colNumY,Region,SP.POP.TOTL) %>%
                arrange(Region)
        }
        # change variable name to the readable ones
        names(df)<- c("Country.Name","Health.Expenditure",yName,"Region","Population")
        
        return(df)
    })
    
    # === update google chart ===
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
                    "%s vs. Health expenditure, %s",
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
    
   
    # === update summary table ===
    output$summary<- renderTable(
        {
            drawdata<- yearData()
            vname<- names(drawdata)[3]
            
            tb<- drawdata %>%
                group_by(Region) %>%
                summarise_(RegionalMean= interp(~mean(x,na.rm= TRUE),x=as.name(vname))) %>%
                filter(Region!="")
            
            return(tb)
        }
    )
    
})