source("common_functions.R")

datafile <- "~/Documents/Coursera/ExploratoryDataAnalysis/data/household_power_consumption.txt"

if (! any(ls() == "powerConsumptionData")) {
        if (file.exists(datafile)) {
                powerConsumptionData <- loadPowerConsumptionData(datafile, c("1/2/2007", "2/2/2007"))
        }
}

if (any(ls() == "powerConsumptionData")) {
        create_plot1(powerConsumptionData, "plot1.png")
}


