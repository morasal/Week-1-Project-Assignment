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

# Create plot3
png("plot3.png", width = 480, height = 480)
par(mfrow = c(1,1))
with(final_df, plot(date.time, Sub_metering_1, col = "black", type = "l", xlab = "", ylab = "Energy sub metering"))
with(final_df, lines(date.time, Sub_metering_2, col = "red"))
with(final_df, lines(date.time, Sub_metering_3, col = "blue"))
legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col=c("black","red","blue"), lty = c(1,1,1))
dev.off()
