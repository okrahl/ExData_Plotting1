# Exploratory Data Analysis Peer Assessments/Course Project 1
library(lubridate)

# do initial directory handling
# store initial working directory
initwd <- getwd()
# set new working directory
# it is assumed that this R script and unzipped data file are located in the 
# same directory
# change the following path to your needs
setwd("/path/to/ExData_Plotting1/data_script_and_plot/")

# handle locale for english weekdays
initlocale <- Sys.getlocale("LC_TIME");
# localize weekdays to meet course project requirements
# http://stackoverflow.com/questions/16716265/
# convert-date-time-from-human-readable-format/16731325#16731325
Sys.setlocale("LC_TIME", "en_US.utf8");

# http://stackoverflow.com/questions/13022299/
# specify-date-format-for-colclasses-argument-in-read-table-read-csv
setAs("character","myDate", function(from) as.Date(from, format="%d/%m/%Y") )
setClass('myDate')

# load data
datafilename <- "household_power_consumption.txt"
colclasses <- c('myDate','character',rep('numeric', 7))
# nearly 4 years from 2006-12 to 2010-11 means 2007-02 is in the first 10%
# or in first 200000 rows. Speed up load of data by skipping 90% tail of lines 
nrows = 200000
datatable <- read.table(file = datafilename, header = TRUE, sep = ";", 
                        na.strings = "?", colClasses = colclasses, 
                        nrows = nrows)
coredata <- subset(datatable, datatable$Date >= as.Date("2007-02-01") & 
                     datatable$Date <= as.Date("2007-02-02"))
dtchar <- paste(coredata$Date, coredata$Time)
# http://stackoverflow.com/questions/20723182/
# plot-of-minute-tick-data-with-correct-x-axis-formatting
x <- strptime(dtchar, format = "%Y-%m-%d %H:%M:%S")

# plot with base plot system

# open PNG device for plotting
# width, height and units are equal to default values, but are given explicitly
# to indicate the requirements of course task
# rule: explicit before implicit
png(filename = "plot4.png", width = 480, height = 480, units = "px",
    bg = "transparent", type = "cairo-png")

# save plot settings
op <- par()
# 2 x 2 subplots in one main plot
par(mfcol = c(2, 2))

# subplot 1: plot from subtask 2
plot(x, coredata$Global_active_power, type = "l",
     xlab = "",
     ylab = "Global Active Power")

# subplot 2: plot from subtask 3
plot(x, coredata$Sub_metering_1, type = "n",
     xlab = "",
     ylab = "Energy sub metering")
# annotate (add elements) to subplot 2
# declare colors used in lines and legend in subplot 2
colors <- c("black", "#FF2500", "#0433FF")
# add data columns as lines to subplot 2
lines(x, coredata$Sub_metering_1, type = "l", col = colors[1])
lines(x, coredata$Sub_metering_2, type = "l", col = colors[2])
lines(x, coredata$Sub_metering_3, type = "l", col = colors[3])

# add legend to subplot 2
leg.txt <- c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
legend("topright", legend = leg.txt, col = colors, lty = 1, bty = "n")

# subplot 3
plot(x, coredata$Voltage, type = "l",
     xlab = "datetime",
     ylab = "Voltage")

# subplot 4
plot(x, coredata$Global_reactive_power, type = "l",
     xlab = "datetime",
     ylab = "Global_reactive_power")

# restore plot settings
par(op)
# close device
dev.off()

# restore the initial settings
setwd(initwd)  # working directory
Sys.setlocale("LC_TIME", initlocale);  # localization