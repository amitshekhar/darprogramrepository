# Step 1: Importing the libraries
library(stringr)
library(dplyr)
library(tidyr)
library(scales)
library(reshape2)
library(plotly)
library(lubridate)

# Step 2: Loading the dataset 
cab_request_data <- read.csv("Uber Request Data.csv",stringsAsFactors = F)
str(cab_request_data)

# Step 3: Data cleaning and extract the derived metrics
# Cleaning Data and converting the dates column 'Request.timestamp'  and 'Drop.timestamp' in the proper POSIXlt format
posix_default_date_format <- "%Y-%m-%d %H:%M:%S"

# a user defined function stringToDate() to convert the date column to proper POSIXlt format
stringToDate <- function(str_date){
  date_var <- NA
  time_field <- strsplit(str_date, " ")[[1]][2]
  split_time_field <- strsplit(time_field, ":")
  if(length(split_time_field[[1]]) ==2){
    str_date <- paste(str_date,':','00',sep="")
  }
  date_var <- strptime(str_date, "%d-%m-%Y %H:%M:%S")
  return(date_var)
}

# converting the dates column 'Request.timestamp'  in the proper POSIXlt format
cab_request_data$Request.timestamp <- str_replace_all(cab_request_data$Request.timestamp,"/","-")
cab_request_data$Request.timestamp <- stringToDate(cab_request_data$Request.timestamp)

# converting the dates column 'Drop.timestamp' in the proper POSIXlt format
cab_request_data$Drop.timestamp <- str_replace_all(cab_request_data$Drop.timestamp,"/","-")
cab_request_data$Drop.timestamp <- stringToDate(cab_request_data$Drop.timestamp)

# Step 4: create the derived data type metrics year,month,day,hour,min for column Request.timestamp
# Extract hour, minute, day for the column Request.timestamp
# Note:Reason not considering month and year because data available for analysing is only for July month and year 2016
cab_request_data$request_min <- format(cab_request_data$Request.timestamp, "%M")
cab_request_data$request_hour <- format(cab_request_data$Request.timestamp, "%H")
cab_request_data$request_day <- format(cab_request_data$Request.timestamp, "%d")

# Step 5: create the derived data type metrics year,month,day,hour,min for column Drop.timestamp
# Extract hour, minute, day for the column Drop.timestamp
# Note:Reason not considering month and year because data available for analysing is only for July month and year 2016
cab_request_data$drop_min <- format(cab_request_data$Drop.timestamp, "%M")
cab_request_data$drop_hour <- format(cab_request_data$Drop.timestamp, "%H")
cab_request_data$drop_day <- format(cab_request_data$Drop.timestamp, "%d")

# Make a new column row_num and assign value 1 to it. This will form the basis of calculating the
# create trip_time_mins which is the difference of the Request time and drop time.
cab_request_data$trip_time_mins <- round(abs(as.numeric(cab_request_data$Request.timestamp 
                                                        - cab_request_data$Drop.timestamp)),2)
cab_request_data$new_val <- rep(1,nrow(cab_request_data))

# Convert the date fields to Charater type for any aggegate operation to perform to avoid the below error
#   Error: Date/times must be stored as POSIXct, not POSIXlt.
cab_request_data$Request.timestamp <- as.character(cab_request_data$Request.timestamp)
cab_request_data$Drop.timestamp <- as.character(cab_request_data$Drop.timestamp)

# Data set along with the derived metrics is ready for our analysis
write.csv(cab_request_data,"cab_request_data.csv")

#Checkpoint 1: Visually identify the most pressing problems for Uber.
# Analysis for percentage distribution of  request status type('Cancelled', 'Trip Completed'  and 'No Cars Available')
# This will give the percentage value for requect 'Cancelled' and 'No Cars Available'
analysis_1_data_cab_requests <- cab_request_data
total_request <- nrow(analysis_1_data_cab_requests)
colnames(analysis_1_data_cab_requests)
cancelled_request_count <- nrow(filter(analysis_1_data_cab_requests, Status=='Cancelled'))
no_cars_available_count <- nrow(filter(analysis_1_data_cab_requests, Status=='No Cars Available'))
trip_completed_request_count <- nrow(filter(analysis_1_data_cab_requests, Status=='Trip Completed'))

# cancelled requests 
percent_cancelled_request <- round(cancelled_request_count/total_request*100,2) #18.74% 
# requests are not served for unavailabilty of cars
percent_no_cars_available_request <-round(no_cars_available_count/total_request*100,2) #39.29% 
#completed requests
percent_trip_completed_request <-  round(trip_completed_request_count/total_request*100,2) #41.97% 

# Plot 1 - % Requests Vs Status(Cancelled, No cars Available, Trip Completed) 
plot_1_status_vs_pickup_point <- ggplot(cab_request_data, aes(x = Status, fill = factor(Pickup.point))) + 
  geom_bar(aes(y = (..count..)/sum(..count..))) + ylab("Percentage ") +
  xlab("Status Type ") + ggtitle('% Requests Vs Status (Cancelled, No cars, Trip Completed)')
plot_1_status_vs_pickup_point

# Checkpoints-1's Conclusion - If we see the graph(plot_status_vs_pickup_point), following conclusions are drawn
#   1.1: Majority of the requests are 'cancelled' when pickup point is City.
#   1.2: Majority of the time, cars are unavailable when pickup point is Airport.

###Checkpoint-2 Start: Find out the gap between supply and demand and show using the plots
# 2.1: Analyse requests i.e. Demand VS supply i.e. Drivers Available
# 2.2: Find the time slots when the highest gap exists

group_requests_by_hour <- group_by(analysis_1_data_cab_requests, request_hour, Pickup.point)
aggregate_requests_by_hour  <- summarise(group_requests_by_hour, requests_or_demand=length(Request.id))

# Analyse Drivers  i.e. Supply
requests_allocated_drivers <- subset(analysis_1_data_cab_requests, !is.na(analysis_1_data_cab_requests$Driver.id))
group_drivers_available_by_hour <- group_by(requests_allocated_drivers, request_hour, Pickup.point )
aggregate_drivers_available_by_hour  <- summarise(group_drivers_available_by_hour, drivers_available_or_supply=length(Request.id))

# Analyse 'Number of requests' Vs 'Drivers Available' i.e. Demand Vs Supply
demand_vs_supply_data <- merge(aggregate_requests_by_hour, aggregate_drivers_available_by_hour, by = c("request_hour","Pickup.point"))

## calculate difference of demand and supply
str(demand_vs_supply_data)
demand_vs_supply_data$gap<- demand_vs_supply_data$requests_or_demand - 
  demand_vs_supply_data$drivers_available_or_supply
demand_vs_supply_data_2 <- demand_vs_supply_data[, c(-2)]

#plot the graph of demand vs supply
melt_demand_vs_supply_data <- melt(demand_vs_supply_data_2, id.vars='request_hour')

plot_2_demand_vs_supply_data  <- ggplot(melt_demand_vs_supply_data,aes(x=request_hour,y=value,fill=factor(variable)))+
  geom_bar(stat="identity",position="dodge")+ 
  scale_fill_manual(values = c("blue","green","red")) +
  xlab("Hours of the day")+ylab("Requests")
plot_2_demand_vs_supply_data

write.csv(demand_vs_supply_data, "demand_vs_supply_data.csv")

# Checkpoint 2.2:Find the types of requests (city-airport or airport-city) for which the gap is the most severe 
# in the identified time slots
analysis_2_data_cab_requests <- cab_request_data[, c(1:4, 8)]

#1 is substracted from the drivers count because NA for Driver.id does not make any sense
number_of_drivers_available <- length(unique(cab_request_data$Driver.id))
print(paste("Number of drivers available is ", number_of_drivers_available)) # 301

colnames(analysis_2_data_cab_requests) 
# group the cab requests by hour status, pickup point, driver
group_cab_requests_by_hour_status <- group_by(analysis_2_data_cab_requests, request_hour, Status)
group_cab_requests_by_hour_status_pickup_point <- group_by(analysis_2_data_cab_requests, request_hour, Status, Pickup.point)
group_cab_requests_by_driver <- group_by(analysis_2_data_cab_requests, Driver.id, Status, Pickup.point)
str(group_cab_requests_by_hour_status)

# summarise the cab requests by hour status, pickup point, driver
summarise_group_cab_requests_by_hour_status <- summarise(group_cab_requests_by_hour_status, length(Request.id))
summarise_group_cab_requests_by_hour_status_pickup.point <- summarise(group_cab_requests_by_hour_status_pickup_point, length(Request.id))
summarise_group_cab_requests_by_driver_id <- summarise(group_cab_requests_by_driver, length(Request.id))
names(summarise_group_cab_requests_by_hour_status)[3] <- "Requests"

plot_3_supply_vs_demand <-ggplot(summarise_group_cab_requests_by_hour_status, aes(x = request_hour, y = Requests, fill = Status)) + 
      geom_bar(stat="identity") +  xlab("Hour of the day") +
      scale_fill_manual(values = c("orange","red","green")) +
      ggtitle('Requests Vs Hour of the Day')
plot_3_supply_vs_demand

write.csv(summarise_group_cab_requests_by_hour_status, "summarise_group_cab_requests_by_hour_status.csv")
write.csv(summarise_group_cab_requests_by_hour_status_pickup.point, "checkpoint_1_data_summary_requests.csv")
write.csv(summarise_group_cab_requests_by_driver_id, "checkpoint_1_data_requests_by_driver_id.csv")

cancelled_and_no_cars_requests <- filter(analysis_2_data_cab_requests, Status != 'Trip Completed')
head(cancelled_and_no_cars_requests)

# Checkpoint 2.1: Find the types of requests (city-airport or airport-city) for which the gap is the most severe 
# in the identified time slots. This is bivariate segmented analysis.        
plot_3_pickup_point_vs_request_hour_with_status <- ggplot(cancelled_and_no_cars_requests, aes(x=Pickup.point, 
                                      y=request_hour, fill = Status)) + geom_jitter(aes(shape=Status, color=Status))
plot_3_pickup_point_vs_request_hour_with_status

# Checkpoints-2's Conclusion - If we see the plot2(plot_2_supply_vs_demand), following conclusions are drawn ;
# 2.1: 
#   Majority of the  requests are 'cancelled' between 5 am and 9 am i.e. morning for pickupoint 'City
#   Majority of the requests are not served for no cars available between 5 and 9 PM i.e. evening
# 2.2 Find the types of requests (city-airport or airport-city) for which the gap is the most severe in the identified time slots:
# Plot 4 and Plot 5  show that the city-airport gap is more between 5am and 9 am for the cancelled requests. 
# Airport-city gap is significantly more between 5 pm and 9 pm for ‘no cars available’.
# The airport-city gap (no cars available) is more severe than the city-airport gap (cancelled requests).


#Checkpoint-3: What do you think is the reason for this issue for the supply-demand gap?

# Checkpoint-3.1:
#Now lets analysis what is causing so many cancellations when pickup point is city
#For cancellations requests analysis, skip the 'No Cars Available'

#Calculate the average trip time:
# average trip time overall
# average trip time from city to airport
# average trip time from airport to city
analysis_3_cab_request_data <- cab_request_data
trip_complete_data <- filter(analysis_3_cab_request_data, Status=='Trip Completed')

length(unique(trip_complete_data$Driver.id))

# Checkpoint-3.1.1: Analyze city and airport requests which are cancelled for the same driver
# when he recieves next requests within an hour while still the curent sript is not completed.
trip_complete_data$Request.timestamp <- as.POSIXct(trip_complete_data$Request.timestamp)
trip_complete_data$Drop.timestamp <- as.POSIXct(trip_complete_data$Drop.timestamp)
str(trip_complete_data)
trip_complete_data$trip_time <- trip_complete_data$Drop.timestamp - trip_complete_data$Request.timestamp
max_trip_time <- max(trip_complete_data$trip_time)
median_trip_time <- median(trip_complete_data$trip_time)
max_trip_time_in_mins <- as.numeric(max_trip_time)
median_trip_time_in_mins <- as.numeric(median_trip_time)

city_requests <- filter(analysis_3_cab_request_data, Status != 'No Cars Available' & Pickup.point=='City' )
airport_requests <- filter(analysis_3_cab_request_data, Status != 'No Cars Available' & Pickup.point=='Airport' )

#considered only the relevant fields for analysis
#now drop time is not required to do the analysis
city_requests <- city_requests[,c(3,4,5,8,9)]
airport_requests <- airport_requests[,c(3,4,5,8,9)]
#add prefix 'city' to column names of df city_requests
names(city_requests)[2:3] <- sapply(names(city_requests)[2:3]
                                                        , function(x){paste("city_",x, sep="")})
#add prefix 'city' to column names of df airport_requests
names(airport_requests)[2:3] <- sapply(names(airport_requests)[2:3]
                                                        , function(x){paste("airport_",x,sep="")})
#add prefix 'city' to column names of df airport_requests
#merge city_requests and airport_requests based on Driver.id

merge_city_and_airport_requests_day_and_hour_wise <- merge(city_requests,airport_requests,
                                        by = c("Driver.id","request_hour","request_day"))

merge_city_and_airport_requests_day_wise <- merge(city_requests,airport_requests,
                                         by = c("Driver.id","request_day"))

colnames(merge_city_and_airport_requests_day_and_hour_wise)
#do not consider the 'trip completed request' for both airport and city picl point points
attach(merge_city_and_airport_requests_day_and_hour_wise)
  #find request raised and allocated to same driver 
  requests_raised_for_same_driver_within_hour <-
           filter(merge_city_and_airport_requests_day_and_hour_wise, (city_Status == 'Trip Completed' &
                    airport_Status == 'Cancellled') | (city_Status == 'Cancelled' &
                    airport_Status == 'Trip Completed')
                  )
detach(merge_city_and_airport_requests_day_and_hour_wise)
  requests_raised_for_same_driver_within_hour$city_Request.timestamp <- 
          as.POSIXct(requests_raised_for_same_driver_within_hour$city_Request.timestamp)
  requests_raised_for_same_driver_within_hour$airport_Request.timestamp <- 
          as.POSIXct(requests_raised_for_same_driver_within_hour$airport_Request.timestamp)

requests_raised_for_same_driver_within_hour$time_duration_between_raised_requests <-
                    round(abs(as.numeric(requests_raised_for_same_driver_within_hour$city_Request.timestamp - 
                            requests_raised_for_same_driver_within_hour$airport_Request.timestamp))/60,2)
requests_raised_for_same_driver_within_hour$
          is_diff_raised_request_time_greate_than_median_trip_time <- 
              requests_raised_for_same_driver_within_hour$time_duration_between_raised_requests < median_trip_time_in_mins

count_requests_raised_for_same_driver_within_hour <- length(requests_raised_for_same_driver_within_hour$is_diff_raised_request_time_greate_than_median_trip_time == TRUE)

plot_4_time_duration_between_requets_within_hour_Vs_request_hour <-
          ggplot(data = requests_raised_for_same_driver_within_hour, aes(x = request_hour , y = time_duration_between_raised_requests )) +
          geom_point()
plot_4_time_duration_between_requets_within_hour_Vs_request_hour
str(requests_raised_for_same_driver_within_hour)

# Checkpoint-3.1.2: Analyze city and airport requests which are cancelled for the same driver
# when he recieves next requests within an day
merge_city_and_airport_requests_day_wise <- merge(city_requests,airport_requests,
                                                  by = c("Driver.id","request_day"))

#do not consider the 'trip completed request' for both airport and city picl point points
attach(merge_city_and_airport_requests_day_wise)

#find request raised and allocated to same driver 
requests_raised_for_same_driver_within_day <-
  filter(merge_city_and_airport_requests_day_wise, (city_Status == 'Trip Completed' &
                                      airport_Status == 'Cancellled') | (city_Status == 'Cancelled' &
                                      airport_Status == 'Trip Completed'))
detach(merge_city_and_airport_requests_day_wise)
requests_raised_for_same_driver_within_day$city_Request.timestamp <- 
          as.POSIXct(requests_raised_for_same_driver_within_day$city_Request.timestamp)
requests_raised_for_same_driver_within_day$airport_Request.timestamp <- 
          as.POSIXct(requests_raised_for_same_driver_within_day$airport_Request.timestamp)

requests_raised_for_same_driver_within_day$time_duration_between_raised_requests <-
  round(abs(as.numeric(requests_raised_for_same_driver_within_day$city_Request.timestamp - 
                         requests_raised_for_same_driver_within_day$airport_Request.timestamp))/60,2)
requests_raised_for_same_driver_within_day$
  is_diff_raised_request_time_greate_than_median_trip_time <- 
  requests_raised_for_same_driver_within_day$time_duration_between_raised_requests > 2 * max_trip_time_in_mins
plot_5_time_duration_between_requests_within_day_Vs_request_hour <-
  ggplot(data = requests_raised_for_same_driver_within_day, aes(x = request_day , y = time_duration_between_raised_requests )) +
  geom_jitter()
plot_5_time_duration_between_requests_within_day_Vs_request_hour
str(requests_raised_for_same_driver_within_day)

write.csv(requests_raised_for_same_driver_within_day,"requests_raised_for_same_driver_within_day.csv")

########################### End of Uber Assignment ##################################
