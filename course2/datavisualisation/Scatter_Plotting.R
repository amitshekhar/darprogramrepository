## -------------Scatter Plots in ggplot---------------------


# Let's play with the geom layer now

# inside geom(), use arguments shape = 1 and size = 4
ggplot(mtcars, aes(x = wt,y = mpg, col = factor(cyl))) + geom_point(shape=1,size=4)
# 1 -circle ,2 - triangle, 3- plus, 4 - multiply, 5 - diamond, 6 - inverted triangle, 

# Note that ALL points are of same shape and size, but not same color

# This is because color is MAPPED to a variable, whereas shape and size are assigned 
# constant values. That's why col is an aesthetic and shape/size are attributes




# Remove shape and size arguments from geom(); 
ggplot(mtcars, aes(x = wt,y = mpg, col = factor(cyl))) + geom_point()

# Use size to show car horsepower.
ggplot(mtcars, aes(x = wt,y = mpg, size = hp)) + geom_point()

# Are you Mapping hp to size or assigning a particlar value to size? 
ggplot(mtcars, aes(x = wt,y = mpg, col = hp, size=disp)) + geom_point()




# -------------Let's practice a few more plots----------------------------------------------

# Show four variables using size and colour


# Map col to hp and size to disp 


# disp means engine displacement





# Use geom_text (instead of geom_point) to display a text variable
ggplot(mtcars, aes(x = wt,y = mpg)) + geom_text(aes(label=cyl))

# This is the first time you are using an aes() function inside a geom layer
# aes(label = cyl) MAPS the label to cylinder value of a data point 


# Type ?geom_text in R console to read more

