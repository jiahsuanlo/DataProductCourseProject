# script to prepare raw data file
# select the topics of interests and assign the subset of data in
# data frame: data

library(dplyr)
library(tidyr)
    

rawdata<- read.csv("./data/8_Topic_en_csv_v2.csv", stringsAsFactors = FALSE, skip=4)
rawCountry<- read.csv("./data/Metadata_Country_8_Topic_en_csv_v2.csv", stringsAsFactors = FALSE)

# pick interesting subset of topics

code<- c("SP.POP.TOTL",    # total population
         "SH.XPD.PCAP",    # health expenditure per capita
         "SH.DTH.INJR.ZS", # Cause of death, by injury (% of total)
         "SH.DYN.MORT",    # Mortality rate, under-5 (per 1,000 live births)
         "SH.STA.BFED.ZS", # Exclusive breastfeeding (% of children under 6 months)
         "SH.STA.BRTC.ZS", # Births attended by skilled health staff (% of total)
         "SH.STA.BRTW.ZS", # Low-birthweight babies (% of births)
         "SH.STA.MALN.ZS", # Prevalence of underweight, weight for age (% of children under 5)
         "SH.STA.OWGH.ZS", # Prevalence of overweight, weight for height (% of children under 5)
         "SN.ITK.DEFC.ZS", # Prevalence of undernourishment (% of population)
         "SP.DYN.LE00.IN", # Life expectancy at birth, total (years)
         "SP.DYN.TFRT.IN") # Fertility rate, total (births per woman)


# select subset
data0<- rawdata %>%
    filter(Indicator.Code %in% code)
# remove last empty column
nc<- ncol(data0)
data0<- data0[,-nc]
# change year names
#names(data0)<- gsub("^X","",names(data0))

# remove non-region data
ind<- rawCountry$Region!=""
rawCountry<- rawCountry[ind,]

# add region column for each country
data<- merge(data0, rawCountry, by="Country.Code") 
data$Region<- factor(data$Region)



# gather year data
data<- gather(data, year, value, X1960:X2015)

# change year names
data$year <- gsub("^X","",data$year)

# construct indicator vector
vIndCode<- unique(data$Indicator.Code)
vIndName<- unique(data$Indicator.Name)

# obtain min and max years
minYear<- min(data$year)
maxYear<- max(data$year)




