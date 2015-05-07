# Function to count the number of records in a file without loading the entire dataset

CountRecordsInFile <- function(fileName) {
        conn <- file(fileName, open = "r")
        noLines <- 0
        noRead <- -1
        cnt <- 10000
        while (noRead == cnt | noRead == -1) {
                lines <- readLines(conn, n=cnt, ok=TRUE)
                noRead <- length(lines)
                # print(noRead)
                noLines <- noLines + noRead
        }
        close(conn)
        noLines
}

# Function to show the count of records in a file and estimated memory needed to load the
# entire file in a data.frame

EstimateSizeOfDf <- function(fileName, hasheader = TRUE, recsep = ";", nastr = "?") {
        norecs <- CountRecordsInFile(fileName)
        firstFewRows <- read.csv(file = fileName, header = hasheader, nrow = 100, sep = recsep)
        classes <- sapply(firstFewRows, class)
        sampleData <- read.csv(file = fileName, sep = recsep, header = hasheader, colClasses = classes, nrow = 10000, na.strings = nastr)
        projected_size <- object.size(sampleData) * (norecs / 10000)
        c("norecs" = norecs, "estimated_size" = projected_size, "estimated_size_mb" = format(projected_size, units = "MB"))
}

# Function to load Power Consumption data from a power consumption data file name filtered by the
# given set of dates that are available in the Data column.
# It is assumed that the input file containing the power consumption data will be in a ; delimited 
# format and will have the following fields in torder below:
# 
# Date;Time;Global_active_power;Global_reactive_power;Voltage;Global_intensity;Sub_metering_1;Sub_metering_2;Sub_metering_3
# The function combines the Date and Time column to add a new column ObservationTime in Date POSIXlt datatype. This is
# useful for plotting

LoadPowerConsumptionData <- function(fileName, dates) {
        library(sqldf)
        library(dplyr)
        dates_in_string <- paste(gsub("^(.*$)$", "'\\1'", dates), collapse = ",")
        sql_clause <- paste("select * from file where Date in (", dates_in_string, ")")
        cData <- read.csv.sql(file = fileName, sep = ";", header = TRUE, sql = sql_clause, nrow=10000)
        closeAllConnections()
        cData$ObservationTime <- strptime(paste(cData$Date, cData$Time), "%d/%m/%Y %H:%M:%S")
        cData[,"Date"] <- as.Date(cData[,"Date"], "%d/%m/%Y")
        cData$Weekday <- weekdays(cData$Date)
        cData <- select(cData, ObservationTime, Date, Weekday, Time, 3:9)
        for (i in 5:11) {
                cData[,i] <- as.numeric(cData[,i])
        }
        cData
}

# Creates a Histogram of column Global_active_power 
# from the input power consumption data frame
#
# If a outfileName is specified, the graphics device is chosen to be that file in png format, otherwise it is plotted on screen.
# If restorePar is TRUE, the graphics parameters are restored to their original state. This parameter is set to TRUE by default
# but can be passed as FALSE if this plot is only a part of a multi-graph plot.

DisplayPlot1 <- function(powerConsumptionData, outFileName = NULL, restorePar = TRUE) {
        if (! is.null(outFileName)) {
                png(outFileName)
        }
        if (restorePar) {
                origWarn <- options("warn")
                origPar <- par()
        }
        
        par(mar = c(5,4,3,3))
        hist(powerConsumptionData$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", main = "Global Active Power")
        
        if (restorePar) {
                ## Reset all the parameters back to original
                options(warn = -1)
                par(origPar)
                options(warn = origWarn$warn)
        }
        if (! is.null(outFileName)) {
                dev.off()
        }
}

# Creates a Line diagram of column Global_active_power (y axis) by ObservationTime (x axis) 
# from the input power consumption data frame
#
# If a outfileName is specified, the graphics device is chosen to be that file in png format, otherwise it is plotted on screen.
# If restorePar is TRUE, the graphics parameters are restored to their original state. This parameter is set to TRUE by default
# but can be passed as FALSE if this plot is only a part of a multi-graph plot.

DisplayPlot2 <- function(powerConsumptionData, outFileName = NULL, restorePar = TRUE) {
        if (! is.null(outFileName)) {
                png(outFileName)
        }
        if (restorePar) {
                origWarn <- options("warn")
                origPar <- par()
        }
        
        par(mar = c(4,4,3,3))
        plot(powerConsumptionData$ObservationTime, powerConsumptionData$Global_active_power, type="n", xlab = "", ylab = "Global Active Power (kilowatts)")
        lines(powerConsumptionData$ObservationTime, powerConsumptionData$Global_active_power)

        if (restorePar) {
                ## Reset all the parameters back to original
                options(warn = -1)
                par(origPar)
                options(warn = origWarn$warn)
        }
        if (! is.null(outFileName)) {
                dev.off()
        }
}

# Creates a Line diagram of columns Sub_metering_1, Sub_metering_2 and Sub_metering 3 (y axis) by ObservationTime (x axis) 
# from the input power consumption data frame
#
# If a outfileName is specified, the graphics device is chosen to be that file in png format, otherwise it is plotted on screen.
# If restorePar is TRUE, the graphics parameters are restored to their original state. This parameter is set to TRUE by default
# but can be passed as FALSE if this plot is only a part of a multi-graph plot.

DisplayPlot3 <- function(powerConsumptionData, outFileName = NULL, restorePar = TRUE) {
        if (! is.null(outFileName)) {
                png(outFileName)
        }
        if (restorePar) {
                origWarn <- options("warn")
                origPar <- par()
        }
        
        par(mar = c(4,4,3,3))
        plot(powerConsumptionData$ObservationTime, powerConsumptionData$Sub_metering_1, type="n", ylim = c(0,40), xlab = "", ylab = "Energy sub metering")
        lines(powerConsumptionData$ObservationTime, powerConsumptionData$Sub_metering_1)
        lines(powerConsumptionData$ObservationTime, powerConsumptionData$Sub_metering_2, col="red")
        lines(powerConsumptionData$ObservationTime, powerConsumptionData$Sub_metering_3, col="blue")
        legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty=c(1,1,1))
        
        if (restorePar) {
                ## Reset all the parameters back to original
                options(warn = -1)
                par(origPar)
                options(warn = origWarn$warn)
        }
        if (! is.null(outFileName)) {
                dev.off()
        }
}

# Creates a  2x2 set of plots from the given power consumption data frame
#
# Top-Left is plot2
# Top-Right is Line Diagram of Voltage (y axis) over Observation Time (x axis)
# Bottom-Left is plot3
# Bottom-Right is Line Diagram of Global_reactive_power (y axis) over Observation Time (x axis)
#
# If a outfileName is specified, the graphics device is chosen to be that file in png format, otherwise it is plotted on screen.
# If restorePar is TRUE, the graphics parameters are restored to their original state. This parameter is set to TRUE by default
# but can be passed as FALSE if this plot is only a part of a multi-graph plot.

DisplayPlot4 <- function(powerConsumptionData, outFileName = NULL, restorePar = TRUE) {
        if (! is.null(outFileName)) {
                png(outFileName)
        }
        if (restorePar) {
                origWarn <- options("warn")
                origPar <- par()
        }
        
        par(mfrow = c(2,2))
        
        # Global active power
        DisplayPlot2(powerConsumptionData, restorePar = FALSE)
        
        # Voltage
        par(mar = c(4,4,3,3))
        plot(powerConsumptionData$ObservationTime, powerConsumptionData$Voltage, type="n", xlab = "Date & Time", ylab = "Voltage")
        lines(powerConsumptionData$ObservationTime, powerConsumptionData$Voltage)
        
        # Energy Sub Metering
        DisplayPlot3(powerConsumptionData, restorePar = FALSE)

        # Global Reactive Power
        par(mar = c(4,4,3,3))
        plot(powerConsumptionData$ObservationTime, powerConsumptionData$Global_reactive_power, type="n", xlab = "Date & Time", ylab = "Global Reactive Power")
        lines(powerConsumptionData$ObservationTime, powerConsumptionData$Global_reactive_power)
        
        if (restorePar) {
                ## Reset all the parameters back to original
                options(warn = -1)
                par(origPar)
                options(warn = origWarn$warn)
        }
        if (! is.null(outFileName)) {
                dev.off()
        }
}
