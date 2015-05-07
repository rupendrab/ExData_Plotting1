# Instructions on Running the scripts for this Project

The following packages must be installed for this package. Please install them before running the source code.

1. sqldf
2. dplyr

The following is a possible way of running the scripts.


```
1. First edit the file set_config.R to change variable datafile to where your Power Consumption File is stored

2. Change Directory to where the source code is

> setwd("~/Documents/Coursera/ExploratoryDataAnalysis/ExData_Plotting1/")

3. Run initial_analysis to count number of records and estimate size of entire data set

> source("initial_analysis.R")
           norecs    estimated_size estimated_size_mb 
        "2075260"   "152553192.704"        "145.5 Mb" 

4. Generate plot1.png

> source("plot1.R")
Loading required package: gsubfn
Loading required package: proto
Loading required package: RSQLite
Loading required package: DBI

Attaching package: ‘dplyr’

The following object is masked from ‘package:stats’:

    filter

The following objects are masked from ‘package:base’:

    intersect, setdiff, setequal, union

Loading required package: tcltk
Warning message:
closing unused connection 3 (~/Documents/Coursera/ExploratoryDataAnalysis/data/household_power_consumption.txt) 

5. Generate plot2.png

> source("plot2.R")

6. Generate plot3.png

> source("plot3.R")

7. Generate plot4.png

> source("plot4.R")

8. You can also view the plots on the console like below.

> DisplayPlot4(powerConsumptionData)
> DisplayPlot1(powerConsumptionData)
> DisplayPlot2(powerConsumptionData)
> DisplayPlot3(powerConsumptionData)
> DisplayPlot4(powerConsumptionData)
```