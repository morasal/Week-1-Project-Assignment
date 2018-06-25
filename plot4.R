library(readr)
library(dplyr)
library(lubridate)
library(stringr)

# Read the entire .txt file into a dataframe format 
data <- read_csv2("household_power_consumption.txt", col_names = TRUE)

# Trying to understand the type of each variable 
str(data)

# Convert the Date column entries to date
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")

# Subset the rows in the original dataset that have been recorded on either "2007-02-01" or "2007-02-02" 
usable_data <- filter(data, Date == "2007-02-01" | Date == "2007-02-02")

# Convert the entries for the last 7 columns to numeric values
final_df <- usable_data %>% 
  mutate_at(c(3:9), funs(as.numeric)) 

# Merge the two Date and Time columns into date.time column and Convert it to date time value
date.time <- strptime(paste(final_df$Date,final_df$Time, sep = " "), format = "%Y-%m-%d %H:%M:%S")
final_df <- cbind(final_df,date.time)

# Change the voltage column's unit from Volt to K-Volt
final_df$Voltage <- final_df$Voltage/1000

# Create plot4
png("plot4.png", width = 480, height = 480)
par(mfrow = c(2,2))

with(final_df, plot(date.time, Global_active_power, type = "l", xlab = "", ylab = "Global Active Power(kilowatts)"))

with(final_df, plot(date.time, Voltage, type = "l", xlab = "datetime", ylab = "Voltage"))

with(final_df, plot(date.time, Sub_metering_1, col = "black", type = "l", xlab = "", ylab = "Energy sub metering"))
with(final_df, lines(date.time, Sub_metering_2, col = "red"))
with(final_df, lines(date.time, Sub_metering_3, col = "blue"))
legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), 
       col=c("black","red","blue"), lty = c(1,1,1), cex = 0.5, bty = "n")

with(final_df, plot(date.time, Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power"))

dev.off()
