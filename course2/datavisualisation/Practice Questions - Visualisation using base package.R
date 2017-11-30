##------- Practice Questions -------------------



# Q1.1 - load the data set "CO2" and store it in a variable plantdata

  plantdata <-CO2
  View(CO2)
  
  # Q1.2 - See the meaning of all the variables using ? command
  
  ?CO2
  
  # Q1.3 - Run the str command and understand the structure of the data set
  str(CO2)

  # Q1.4 - Use plot() command to plot the uptake vs the conc. Use colour for Type
  plot(plantdata$uptake, plantdata$conc, col = plantdata$Type)

  # Q1.5 - Use box plot to compare the CO2 uptake by 

#a) Various plants
  boxplot(plantdata$uptake)
  boxplot(plantdata$uptake, data = plantdata, col = "lightgray")
  
  boxplot(plantdata$conc ~ plantdata$uptake, col = plantdata$Type )
  ?boxplot
  
#b) Various plant types
  boxplot(plantdata$Plant)
  
#c) Various treatments

  
  # Q1.6 - Plot a histogram to study the most common uptake among Mississippi and Quebec plants
  #Read the following link to see possible solutions: http://stackoverflow.com/questions/8293547/how-to-plot-a-subset-of-a-data-frame-in-r
  #Then plot them side by side
  par(mfrow = c(1,2))
  hist(plantdata$uptake[plantdata$Type == "Quebec"])
  hist(plantdata$uptake[plantdata$Type == "Mississippi"])

  # Q1.7 - Plot the uptake vs conc using ggplot functions. Use shape for type and col for treatment. 
  # Try using different sizes for better visual clarity.
  ggplot(plantdata, aes(x = plantdata$uptake, y = plantdata$conc, 
                        shape = plantdata$Type, col = plantdata$Treatment)) + geom_point(size = 3)
  


 
