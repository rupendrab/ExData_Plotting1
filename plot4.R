source("common_functions.R")
source("set_config.R")

# Load the data frame if it is not loaded already

if (! any(ls() == "powerConsumptionData")) {
        if (file.exists(datafile)) {
                powerConsumptionData <- LoadPowerConsumptionData(datafile, analDates)
        }
}

# If the power consumption data is loaded, generate the corresponding plot

if (any(ls() == "powerConsumptionData")) {
        # Refer to common_functions.R for the source code of DisplayPlot4 function
        DisplayPlot4(powerConsumptionData, "plot4.png")
}
