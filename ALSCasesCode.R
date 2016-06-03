## R code adapted from Kyle Walker, PhD, Texas Christian University (https://github.com/walkerke/teaching-with-datavis/blob/master/pyramids/rcharts_pyramids.R)[2]

library(XML)

## Read in incidence and survival rate files on repository or see below

maleinc <- read.csv("MaleIncidence_vF.csv", sep = ",", header = TRUE, stringsAsFactors = FALSE)
femaleinc <- read.csv("FemaleIncidence_vF.csv", sep = ",", header = TRUE, stringsAsFactors = FALSE)

## Code:

ALSCases<-function(countries, year, gender){
  popdata<- function(country, year, gender) {
    c1 <- "http://www.census.gov/population/international/data/idb/region.php?N=%20Results	%20&T=10&A=separate&RT=0&Y="  
    c2 <- "&R=-1&C="
    yrs <- gsub(" ", "", toString(year))
    url <- paste0(c1, yrs, c2, country)
    df <- data.frame(readHTMLTable(url))
    nms <- c("Year", "Age", "Both Sexes Population", "Male", "Female", "percent", "pctMale", "pctFemale", 	"sexratio")  
    names(df) <- nms
    cols <- c(1, 3:9)
    df[,cols] <- apply(df[,cols], 2, function(x) as.numeric(as.character(gsub(",", "", 		x))))
    mnames <- c("male", "Male", "m", "M")
    fnames <- c("female", "Female", "f", "F")
    if(gender %in% mnames){
      keep <- c("Male")
      row.names(maleinc) <- c("Survival", "0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65-69", "70-74", "75-79", "80-84", "85-89", "90-94", "95-99", ">100")
      prev <- do.call(rbind.data.frame, apply(maleinc[2:dim(maleinc)[1], 2:length(maleinc)], 1, function(x) x*maleinc[1, 2:length(maleinc)]))
      write.csv(prev, file = "maleprev.csv")
      assign("prev", prev, envir = .GlobalEnv)
    }
    if(gender %in% fnames){
      keep <- c("Female")
      row.names(femaleinc) <- c("Survival", "0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65-69", "70-74", "75-79", "80-84", "85-89", "90-94", "95-99", ">100")
      prev <- do.call(rbind.data.frame, apply(femaleinc[2:dim(femaleinc)[1], 2:length(femaleinc)], 1, function(x) x*femaleinc[1, 2:length(femaleinc)]))
      write.csv(prev, file = "femaleprev.csv")
      assign("prev", prev, envir = .GlobalEnv)
    }
    df <- df[, keep, drop=FALSE]
    return(df)
  }
  data<-data.frame(sapply(countries, popdata, year, gender))
  data<-`names<-`(data, countries)
  drop.ref <- seq(1, dim(data)[1], 22)
  cut.popdata<-data[-(drop.ref), ]
  cases <- cut.popdata
  for (i in 1:length(countries)){
    country.code <- countries[i]
    cases[country.code] <- cut.popdata[, country.code] * prev[, country.code]/100000
  }
  cases$Year <- rep(year, each=21)
  cases$Ages <- c("0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49",
                  "50-54", "55-59", "60-64", "65-69", "70-74", "75-79", "80-84", "85-89", "90-94", "95-99", ">100")
  cases <- cases[, c("Year", "Ages", countries)]
  write.csv(cases, file= paste(ifelse(gender=="m"|gender=="M"|gender=="male"| gender=="Male", "Male", "Female"), "Cases.csv", sep=""), row.names = FALSE)
  return(cases)}

#Run the R code for males as follows:
ALSCases(c('LY', 'US', 'UY', 'CH', 'IR', 'JA', 'TW', 'RI', 'NZ'), c(2015, 2040), 'male')
#This will output "maleprev.csv" containing the age-specific male prevalence rates by country, and "MaleCases.csv" containing the number of male cases by country, year and age group to the working directory.

#Run the R code for females as follows:
ALSCases(c('LY', 'US', 'UY', 'CH', 'IR', 'JA', 'TW', 'RI', 'NZ'), c(2015, 2040), 'femaleÕ)
         #This will output "femaleprev.csv" containing the age-specific female prevalence rates by country, and "FemaleCases.csv" containing the number of female cases by country, year and age group to the working directory.
         
         
         #save the following text as "FemaleIncidence.csv" in the working directory
         Country,CH,US,JA,UY,IR,LY,EU,TW,NZ,RI
         Survival,2.5,2.42,2.5,4,5,3.5,2.39,2.5,2.3,2.39
         0-4,0,NA,NA,NA,0,NA,NA,0.45,0.4,NA
         5-9,0,NA,NA,NA,0,NA,NA,0.4,0.4,NA
         10-14,0,NA,NA,NA,0,NA,NA,0.18,0.4,NA
         15-19,0,0,NA,NA,0,NA,NA,0.35,0.4,NA
         20-24,0,0,0,NA,0,0,0.1,0.21,0.4,0.28
         25-29,0.14,0.08,0,0.21,0.17,0,0.4,0.17,0.4,0
         30-34,0.13,0.08,0.1,0.21,0.22,0.81,0.1,0.27,0.4,0
         35-39,0.22,0.36,0.1,0.71,0.25,0.81,0.2,0.73,0.4,0
         40-44,0.12,0.36,0.7,0.71,0.29,2.17,0.8,1.08,0.4,0.72
         45-49,0.46,2.98,0.7,1.05,0.85,2.17,1.5,1.38,0.4,0.58
         50-54,0.78,2.98,1.5,1.05,1.06,3.76,2.3,1.3,3.8,0.52
         55-59,1.41,6.13,1.5,2.9,0.91,3.76,2.8,1.5,3.8,0.33
         60-64,1.4,6.13,3.1,2.9,1.13,2.27,5.8,2.54,5,3.02
         65-69,2.35,7.41,3.1,2.55,1.48,2.27,6.7,2.03,5,2.17
         70-74,1.52,7.41,5.1,2.55,2.11,2.56,6.5,3.2,12.1,1.5
         75-79,1.02,5.54,5.1,1.63,0.85,2.56,7,1.7,12.1,NA
         80-84,1.3,5.54,2.9,1.63,0,2.56,4,1.04,4.8,NA
         85-89,1.3,5.54,2.9,1.63,0,2.56,2.6,1.04,4.8,NA
         90-94,1.3,5.54,2.9,1.63,0,2.56,2.6,1.04,4.8,NA
         95-99,1.3,5.54,2.9,1.63,0,2.56,2.6,1.04,4.8,NA
         >100,1.3,5.54,2.9,1.63,0,2.56,2.6,1.04,4.8,NA
         
         #save the following text as "MaleIncidence.csv" in the working directory
         Country,CH,US,UY,IR,LY,JA,EU,TW,NZ,RI
         Survival,2.25,3,4.33,3.25,3.5,2.25,2.39,2.25,2.3,2.39
         0-4,0,NA,NA,0,NA,NA,NA,0.56,0.5,NA
         5-9,0,NA,NA,0,NA,NA,NA,0.69,0.5,NA
         10-15,0,NA,NA,0,NA,NA,NA,0.62,0.5,NA
         15-19,0,0.11,NA,0.15,NA,NA,NA,0.8,0.5,NA
         20-24,0,0.11,NA,0.07,0.11,0,0.1,0.42,0.5,0
         25-29,0,0.79,0.22,0,0.11,0,0.3,0.39,0.5,0
         30-34,0.16,0.79,0.22,0.21,2.32,0.1,0.3,0.52,0.5,0
         35-39,0.92,1.63,1.73,0.57,2.32,0.1,0.6,0.73,0.5,0.28
         40-44,0.98,1.63,1.73,0.81,2.84,0.5,1.4,1.29,0.5,0.72
         45-49,0.3,2.49,2.82,0.97,2.84,0.5,2.2,1.53,0.5,0.28
         50-54,0.72,2.49,2.82,1.99,8.14,2.4,2.4,2.02,3.7,1.39
         55-59,1.81,6.42,6.6,2.67,8.14,2.4,5.7,2.2,3.7,2.67
         60-64,3.99,6.42,6.6,3.39,8.11,5.4,5.6,4.02,10.6,4.85
         65-69,1.92,10.17,7.68,2.23,8.11,5.4,8.7,4.51,10.6,2.17
         70-74,3.6,10.17,7.68,2.81,0,8.3,10.7,4.14,18.2,0.89
         75-79,2.58,7.18,6.48,1.64,0,8.3,9.7,2.81,18.2,NA
         80-84,1.53,7.18,6.48,2.38,0,5.1,7.4,0.92,7.6,NA
         85-89,1.53,7.18,6.48,2.38,0,5.1,2,0.92,7.6,NA
         90-94,1.53,7.18,6.48,2.38,0,5.1,2,0.92,7.6,NA
         95-99,1.53,7.18,6.48,2.38,0,5.1,2,0.92,7.6,NA
         >100,1.53,7.18,6.48,2.38,0,5.1,2,0.92,7.6,NA