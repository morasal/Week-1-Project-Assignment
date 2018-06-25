library(readr)
library(dplyr)
library(lubridate)

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

# Create plot1
png("plot1.png", width = 480, height = 480)
hist(final_df$Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power(kilowatts)")
dev.off()



