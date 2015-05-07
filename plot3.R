source("common_functions.R")
source("set_config.R")

# Load the data frame if it is not loaded already

if (! any(ls() == "powerConsumptionData")) {
        if (file.exists(datafile)) {
                powerConsumptionData <- LoadPowerConsumptionData(datafile, c("1/2/2007", "2/2/2007"))
        }
}

# If the power consumption data is loaded, generate the corresponding plot

if (any(ls() == "powerConsumptionData")) {
        # Refer to common_functions.R for the source code of create_plot3 function
        DisplayPlot3(powerConsumptionData, "plot3.png")
}
