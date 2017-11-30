
##-------------Bar Charts in ggplot--------------------

# setting the ggplot object
cyl.am <- ggplot(mtcars, aes(x=factor(cyl)))
# plot does not gets displayed as we haven't added any geometry

cyl.am + geom_bar()

cyl.am + geom_bar(col="red")
cyl.am + geom_bar(fill="red")

cyl.am <- cyl.am  + aes(fill=factor(am))
cyl.am + geom_bar()

cyl.am + geom_bar(position = "fill")
cyl.am + geom_bar(fill = "red")
# The base layer is available : cyl.am

# Add geom (position = "stack" by default)


# Fill - show proportion


# Effective Visualisation
# You want to plot the bar chart you drew in the previous segment in a different way. The values of both the 
# factors should appear side by side for all the cylinder values. Write down the correct code.
# You can also search some ways to make it look even better by introducing overlap. Here are some hints for you. 
# Write the code for doing this as well.
cyl.am <- ggplot(mtcars, aes(x = factor(cyl), fill=factor(am)))
cyl.am + geom_bar(alpha = 1, position = position_dodge(width = 2))



