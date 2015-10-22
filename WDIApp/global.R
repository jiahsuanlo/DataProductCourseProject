# script to prepare raw data file
# select the topics of interests and assign the subset of data in
# data frame: data

library(dplyr)
library(tidyr)
    

# === read raw data ===
rawdata<- read.csv("./data/8_Topic_en_csv_v2.csv",
                   stringsAsFactors = FALSE, skip=4, sep = ",",fileEncoding="UTF-8-BOM")
rawCountry<- read.csv("./data/Metadata_Country_8_Topic_en_csv_v2.csv", 
                      stringsAsFactors = FALSE, sep=",",fileEncoding="UTF-8-BOM")
rawIndicator<- read.csv("./data/Metadata_Indicator_8_Topic_en_csv_v2.csv",
                        stringsAsFactors = FALSE, sep=",",fileEncoding="UTF-8-BOM")


# === clean data ===

# select country, indicator, and values only
essentialdata<- rawdata %>%
    select(Country.Code, Indicator.Code, X1960:X2015)

# re-arrange data so that each indicator is a column
cleandata<- essentialdata %>%
    gather(year,value,X1960:X2015) %>%
    spread(Indicator.Code, value)

# change year into integer class
cleandata$year <- gsub("^X","",cleandata$year)
cleandata$year <- as.integer(cleandata$year)


# === collect set of indicators ===
# construct indicator vector
indicators<- data.frame(code= unique(rawIndicator$INDICATOR_CODE),
                        name= unique(rawIndicator$INDICATOR_NAME))
# remove expenditure and population variables
ind<- (indicators$code!="SH.XPD.PCAP") & (indicators$code!="SP.POP.TOTL")
indicators<- indicators[ind,]

# === Select only health-related data ===
codeLeft<- 
    c(
        "SH.ANM.CHLD.ZS       ",    # Prevalence of anemia among children (% of children under 5)
        "SH.ANM.NPRG.ZS       ",    # Prevalence of anemia among non-pregnant women (% of women ages 15-49)
        "SH.DTH.COMM.ZS       ",    # Cause of death, by communicable diseases and maternal, prenatal and nutrition conditions (% of total)
        "SH.DTH.IMRT          ",    # Number of infant deaths
        "SH.DTH.INJR.ZS       ",    # Cause of death, by injury (% of total)
        "SH.DTH.MORT          ",    # Number of under-five deaths
        "SH.DTH.NCOM.ZS       ",    # Cause of death, by non-communicable diseases (% of total)
        "SH.DTH.NMRT          ",    # Number of neonatal deaths
        "SH.DYN.MORT          ",    # Mortality rate, under-5 (per 1,000 live births)
        "SH.DYN.MORT.FE       ",    # Mortality rate, under-5, female (per 1,000 live births)
        "SH.DYN.MORT.MA       ",    # Mortality rate, under-5, male (per 1,000 live births)
        "SH.DYN.NMRT          ",    # Mortality rate, neonatal (per 1,000 live births)
        "SH.HIV.0014          ",    # Children (0-14) living with HIV
        "SH.HIV.1524.FE.ZS    ",    # Prevalence of HIV, female (% ages 15-24)
        "SH.HIV.1524.MA.ZS    ",    # Prevalence of HIV, male (% ages 15-24)
        "SH.IMM.IDPT          ",    # Immunization, DPT (% of children ages 12-23 months)
        "SH.IMM.MEAS          ",    # Immunization, measles (% of children ages 12-23 months)
        "SH.MED.BEDS.ZS       ",    # Hospital beds (per 1,000 people)
        "SH.MED.PHYS.ZS       ",    # Physicians (per 1,000 people)
        "SH.MMR.RISK.ZS       ",    # Lifetime risk of maternal death (%)
        "SH.PRG.ANEM          ",    # Prevalence of anemia among pregnant women (%)
        "SH.PRV.SMOK.FE       ",    # Smoking prevalence, females (% of adults)
        "SH.PRV.SMOK.MA       ",    # Smoking prevalence, males (% of adults)
        "SH.STA.ACSN          ",    # Improved sanitation facilities (% of population with access)
        "SH.STA.ACSN.RU       ",    # Improved sanitation facilities, rural (% of rural population with access)
        "SH.STA.ACSN.UR       ",    # Improved sanitation facilities, urban (% of urban population with access)
        "SH.STA.BRTC.ZS       ",    # Births attended by skilled health staff (% of total)
        "SH.STA.MMRT          ",    # Maternal mortality ratio (modeled estimate, per 100,000 live births)
        "SH.TBS.CURE.ZS       ",    # Tuberculosis treatment success rate (% of new cases)
        "SH.TBS.DTEC.ZS       ",    # Tuberculosis case detection rate (%, all forms)
        "SH.TBS.INCD          ",    # Incidence of tuberculosis (per 100,000 people)
        "SH.VAC.TTNS.ZS       ",    # Newborns protected against tetanus (%)
        "SH.XPD.EXTR.ZS       ",    # External resources for health (% of total expenditure on health)
        "SH.XPD.OOPC.TO.ZS    ",    # Out-of-pocket health expenditure (% of total expenditure on health)
        "SH.XPD.OOPC.ZS       ",    # Out-of-pocket health expenditure (% of private expenditure on health)
        "SN.ITK.DEFC.ZS       ",    # Prevalence of undernourishment (% of population)
        "SN.ITK.DFCT          ",    # Depth of the food deficit (kilocalories per person per day)
        "SP.ADO.TFRT          ",    # Adolescent fertility rate (births per 1,000 women ages 15-19)
        "SP.DYN.AMRT.FE       ",    # Mortality rate, adult, female (per 1,000 female adults)
        "SP.DYN.AMRT.MA       ",    # Mortality rate, adult, male (per 1,000 male adults)
        "SP.DYN.CBRT.IN       ",    # Birth rate, crude (per 1,000 people)
        "SP.DYN.CDRT.IN       ",    # Death rate, crude (per 1,000 people)
        "SP.DYN.IMRT.FE.IN    ",    # Mortality rate, infant, female (per 1,000 live births)
        "SP.DYN.IMRT.IN       ",    # Mortality rate, infant (per 1,000 live births)
        "SP.DYN.IMRT.MA.IN    ",    # Mortality rate, infant, male (per 1,000 live births)
        "SP.DYN.LE00.FE.IN    ",    # Life expectancy at birth, female (years)
        "SP.DYN.LE00.IN       ",    # Life expectancy at birth, total (years)
        "SP.DYN.LE00.MA.IN    ",    # Life expectancy at birth, male (years)
        "SP.DYN.TFRT.IN       ",    # Fertility rate, total (births per woman)
        "SP.DYN.TO65.FE.ZS    ",    # Survival to age 65, female (% of cohort)
        "SP.DYN.TO65.MA.ZS    ",    # Survival to age 65, male (% of cohort)
        "SP.POP.0014.TO.ZS    ",    # Population ages 0-14 (% of total)
        "SP.POP.1564.TO.ZS    ",    # Population ages 15-64 (% of total)
        "SP.POP.65UP.TO.ZS    ",    # Population ages 65 and above (% of total)
        "SP.POP.DPND          ",    # Age dependency ratio (% of working-age population)
        "SP.POP.DPND.OL       ",    # Age dependency ratio, old (% of working-age population)
        "SP.POP.DPND.YG       ",    # Age dependency ratio, young (% of working-age population)
        "SP.POP.GROW          ")    # Population growth (annual %)

# obtain left index
indLeft<- match(trimws(codeLeft), indicators$code)
indicators<- indicators[indLeft,]

# sort indicators by name
indicators <- arrange(indicators, name)

# ensure the code and name of indicators are strings
indicators$name<- as.character(indicators$name)
indicators$code<- as.character(indicators$code)

# === Construct Region and Country name Info ===
# remove non-regional data
ind<- rawCountry$Region!=""
rawCountry<- rawCountry[ind,]

# add region column for each country+
data<- left_join(cleandata, rawCountry)
data$Region<- factor(data$Region)




# === obtain iniital min and max years ===
minYear<- min(data$year)
maxYear<- max(data$year)




