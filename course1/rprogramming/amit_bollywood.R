 #	Import the Bollywood data set in Rstudio in a variable named bollywood
  # getwd()  #this has been run to get the current working directory
  # setwd("/Users/ashekha/Documents/DS/R") #setting the working directory
  bollywood <- read.csv("bollywood.csv", header = TRUE) # importing the Bollywood data in a variable named bollywood
  View(bollywood) #View the bollywood data set

#	When you import a data set, R stores character vectors as factors (by default)
# You can check the structure of the data frame by using str()
  str(bollywood)

# You can change the attribute 'Movie' from factor to character type using the given command
  bollywood$Movie <- as.character(bollywood$Movie) # changing the attribute 'Movie' from factor to character type
  str(bollywood) # checking the structure of the data frame with changed attribute 'Movie' from factor to character type by using str()

#Q1.
#	Access the last 10 movies (from the bottom of the Bollywood data frame) using column bollywood$Movie
# Store the names of those movies in last_10 vector (in the same order)
  last_10 <- tail(bollywood$Movie,10) 
  last_10 

#Q2.
#	Find out the total number of  missing values (NA) in the bollywood data frame.
# Store the result in na_bollywood vector
  na_bollywood <- sum(sapply(bollywood, function(x) sum(is.na(x))))
	na_bollywood # total number of  missing values (NA) in the bollywood data frame is 3
	
#Q3
#	Write the command to find out which movie tops the list in terms of Total Collections
# Store the movie name in variable named top_movie
  top_movie <-  bollywood[which(bollywood$Tcollection == max(bollywood$Tcollection)),]
  View(top_movie)
  
#Q4
#	Write the command to find out which movie comes second on the list in terms of Total Collections
# Store the movie name in variable named top_2_movie
  top_2_tcollection <- head(sort(bollywood$Tcollection, decreasing = TRUE),2)
  top_2_tcollection
  top_2_movie <- bollywood[which(bollywood$Tcollection == top_2_tcollection[2]),][1]
  top_2_movie
	
# Now let's find out the movies shot by Shahrukh, Akshay and Amitabh separately.
# subset() function is used for that. The code has already been written for you. 
	
	shahrukh <- subset(bollywood, Lead == "Shahrukh")
	akshay <- subset(bollywood, Lead == "Akshay")
	amitabh <- subset(bollywood, Lead  == "Amitabh")

# You can view what the above data frames look like
	View(shahrukh) # view what the shahrukh data frame look like
	View(akshay) # view what the shahrukh data frame look like
	View(amitabh) # view what the shahrukh data frame look like
		   
#Q5
#	What is the total collection of Shahrukh, Akshay and Amitabh movies individually?
# You can use	a column named 'Tcollection' for this 
  shahrukh_collection <- sum(shahrukh$Tcollection)
  shahrukh_collection
  
	akshay_collection <- sum(akshay$Tcollection)
	akshay_collection
    
	amitabh_collection <- sum(amitabh$Tcollection)
	amitabh_collection
    
#Q6  
# Write command/s to find out how many movies are in Flop, Average, Hit and Superhit categories in the entire Bollywood data set.
#You can use SAPPLY function if you want to apply a function specific columns in a data frame 
#You can write a command to find the maximum value of Ocollection, Wcollection, Fwcollecion and Tcollection using sapply
	total_flop_movies <- sum(sapply(bollywood$Verdict, function(x) x == "Flop"))
	total_flop_movies
	
	total_average_movies <- sum(sapply(bollywood$Verdict, function(x) x == "Average"))
	total_average_movies
	
	total_hit_movies <- sum(sapply(bollywood$Verdict, function(x) x == "Hit"))
	total_hit_movies
	
	total_superhit_movies <- sum(sapply(bollywood$Verdict, function(x) x == "Super Hit"))
	total_superhit_movies
	
#Q7 
# Write a command to find the names of the movies which have the maximum Ocollection, Wcollection, Fwcollecion & Tcollection
# Store the names of 4 movies in same sequence in movie_result vector

	bollywood$Ocollection[is.na(bollywood$Ocollection)] <- 0
	bollywood$Ocollection
	bollywood$Wcollection[is.na(bollywood$Wcollection)] <- 0
	bollywood$Wcollection
	bollywood$Fwcollection[is.na(bollywood$Fwcollection)] <- 0
	bollywood$Fwcollection
	bollywood$Tcollection[is.na(bollywood$Tcollection)] <- 0
	bollywood$Tcollection
	
	movie_result = as.character(bollywood[apply(bollywood[,4:7],2, which.max),1])
	movie_result
	
