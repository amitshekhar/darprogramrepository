##------------Plotting Larger Data Sets-----------------


# See structure of diamonds data frame
View(diamonds)
str(diamonds)

# Classes ‘tbl_df’, ‘tbl’ and 'data.frame':	53940 obs. of  10 variables:
#  $ carat  : num  0.23 0.21 0.23 0.29 0.31 0.24 0.24 0.26 0.22 0.23 ...
#  $ cut    : Ord.factor w/ 5 levels "Fair"<"Good"<..: 5 4 2 4 2 3 3 3 1 3 ...
#  $ color  : Ord.factor w/ 7 levels "D"<"E"<"F"<"G"<..: 2 2 2 6 7 7 6 5 2 5 ...
#  $ clarity: Ord.factor w/ 8 levels "I1"<"SI2"<"SI1"<..: 2 3 5 4 2 6 7 3 4 5 ...
#  $ depth  : num  61.5 59.8 56.9 62.4 63.3 62.8 62.3 61.9 65.1 59.4 ...
#  $ table  : num  55 61 65 58 58 57 57 55 61 61 ...
#  $ price  : int  326 326 327 334 335 336 336 337 337 338 ...
#  $ x      : num  3.95 3.89 4.05 4.2 4.34 3.94 3.95 4.07 3.87 4 ...
#  $ y      : num  3.98 3.84 4.07 4.23 4.35 3.96 3.98 4.11 3.78 4.05 ...
#  $ z      : num  2.43 2.31 2.31 2.63 2.75 2.48 2.47 2.53 2.49 2.39 ...


# Plot carat on x and price on y axis; use geom_point
# This is a plot with over 50,000 data points
ggplot(diamonds,aes(x=carat,y=price))+geom_point()



# Add geom_smooth() after the geom_point() to fit a smooth line, just use a + sign
# Note that + sign simply adds a geometric layer geom_smooth over geom_point
# You can add as many geometric layers as you wish!  
ggplot(diamonds,aes(x=carat,y=price))+geom_point() + geom_smooth() 




# Show only the smooth line: Remove the geom_point layer
ggplot(diamonds,aes(x=carat,y=price)) + geom_smooth() 



# Map col to clarity in the aes() of ggplot
# Diamonds come in different clarity levels, each having its own pricing methodology
# Can you see which clarity level is the cheapest? 
ggplot(diamonds,aes(x=carat,y=price, col=clarity))+geom_point()



# Keep the color settings as they are (col mapped to clarity) 
# Plot using geom_point instead of geom_smooth and use alpha = 0.4 inside geom_point
# Alpha is a measure of transparency and is useful to plot large data sets neatly 
# (somewhat neatly)



# Try changing alpha from 0.9 to 0.1 (it's a fraction)




## Visual as Objects:
# dia_plot <- ggplot(diamonds, aes(x = carat, y = price))

diamond_plot <- ggplot(diamonds, aes(x = carat, y = price))

# Expand dia_plot by adding geom_point() with alpha set to 0.2
# dia_plot <- dia_plot + geom_point(alpha = 0.2)
diamond_plot + geom_smooth()

diamond_plot +geom_point(alpha = 0.5)


