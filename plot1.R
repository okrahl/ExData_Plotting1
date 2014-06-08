# Exploratory Data Analysis Peer Assessments/Course Project 1
library(data.table)

# do initial directory handling
# store initial working directory
initwd <- getwd()
# set new working directory
# it is assumed that this R script and unzipped data file are located in the 
# same directory
# change the following path to your needs
setwd("/path/to/ExData_Plotting1/data_script_and_plot/")

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

# plot with base plot system
# open PNG device for plotting
# width, height and units are equal to default values, but are given explicitly
# to indicate the requirements of course task
# rule: explicit before implicit

# open device
png(filename = "plot1.png", width = 480, height = 480, units = "px",
    bg = "transparent", type = "cairo-png")
# do the plot
hist(coredata$Global_active_power,
     col = "red",
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)")
# close device
dev.off()

# restore the initial working directory
setwd(initwd)