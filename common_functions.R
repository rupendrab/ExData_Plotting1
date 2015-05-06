loadPowerConsumptionData <- function(fileName, dates) {
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

create_plot1 <- function(powerConsumptionData, outFileName = NULL, restorePar = TRUE) {
        if (restorePar) {
                origWarn <- options("warn")
                origPar <- par()
        }
        if (! is.null(outFileName)) {
                png(outFileName)
        }
        
        par(mar = c(5,4,3,3))
        hist(powerConsumptionData$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", main = "Global Active Power")
        
        if (! is.null(outFileName)) {
                dev.off()
        }
        if (restorePar) {
                ## Reset all the parameters back to original
                options(warn = -1)
                par(origPar)
                options(warn = origWarn$warn)
        }
}

create_plot2 <- function(powerConsumptionData, outFileName = NULL, restorePar = TRUE) {
        if (restorePar) {
                origWarn <- options("warn")
                origPar <- par()
        }
        if (! is.null(outFileName)) {
                png(outFileName)
        }
        
        par(mar = c(4,4,3,3))
        plot(powerConsumptionData$ObservationTime, powerConsumptionData$Global_active_power, type="n", xlab = "", ylab = "Global Active Power (kilowatts)")
        lines(powerConsumptionData$ObservationTime, powerConsumptionData$Global_active_power)

        if (! is.null(outFileName)) {
                dev.off()
        }
        if (restorePar) {
                ## Reset all the parameters back to original
                options(warn = -1)
                par(origPar)
                options(warn = origWarn$warn)
        }
}

create_plot3 <- function(powerConsumptionData, outFileName = NULL, restorePar = TRUE) {
        if (restorePar) {
                origWarn <- options("warn")
                origPar <- par()
        }
        if (! is.null(outFileName)) {
                png(outFileName)
        }
        
        par(mar = c(4,4,3,3))
        plot(powerConsumptionData$ObservationTime, powerConsumptionData$Sub_metering_1, type="n", ylim = c(0,40), xlab = "", ylab = "Energy sub metering")
        lines(powerConsumptionData$ObservationTime, powerConsumptionData$Sub_metering_1)
        lines(powerConsumptionData$ObservationTime, powerConsumptionData$Sub_metering_2, col="red")
        lines(powerConsumptionData$ObservationTime, powerConsumptionData$Sub_metering_3, col="blue")
        legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty=c(1,1,1))
        
        if (! is.null(outFileName)) {
                dev.off()
        }
        if (restorePar) {
                ## Reset all the parameters back to original
                options(warn = -1)
                par(origPar)
                options(warn = origWarn$warn)
        }
}

create_plot4 <- function(powerConsumptionData, outFileName = NULL, restorePar = TRUE) {
        if (restorePar) {
                origWarn <- options("warn")
                origPar <- par()
        }
        if (! is.null(outFileName)) {
                png(outFileName)
        }
        
        par(mfrow = c(2,2))
        
        # Global active power
        create_plot2(powerConsumptionData, restorePar = FALSE)
        
        # Voltage
        par(mar = c(4,4,3,3))
        plot(powerConsumptionData$ObservationTime, powerConsumptionData$Voltage, type="n", xlab = "Date & Time", ylab = "Voltage")
        lines(powerConsumptionData$ObservationTime, powerConsumptionData$Voltage)
        
        # Energy Sub Metering
        create_plot3(powerConsumptionData, restorePar = FALSE)

        # Global Reactive Power
        par(mar = c(4,4,3,3))
        plot(powerConsumptionData$ObservationTime, powerConsumptionData$Global_reactive_power, type="n", xlab = "Date & Time", ylab = "Global Reactive Power")
        lines(powerConsumptionData$ObservationTime, powerConsumptionData$Global_reactive_power)
        
        if (! is.null(outFileName)) {
                dev.off()
        }
        if (restorePar) {
                ## Reset all the parameters back to original
                options(warn = -1)
                par(origPar)
                options(warn = origWarn$warn)
        }
}
