##-------------- Basic Plotting in R --------------

# See structure of the iris data frame 
iris <- iris
View(iris)
str(iris)



# Plot Sepal length and width on x and y axes respectively
plot(iris$Sepal.Length,iris$Sepal.Width)



# Add a layer of petal length and width using points, use col = "red" 
points(iris$Petal.Length,iris$Petal.Width,col = "red")



# Plot Species (factor) as colors; note that now we assign color to a variable in the data frame 
# and R assigns a color to each species automatically
plot(iris$Sepal.Length,iris$Sepal.Width,col=iris$Species)

# Add Labels
title("iris", sub = "iris subtitle",
      cex.main = 2,   font.main= 4, col.main= "blue",
      cex.sub = 0.75, font.sub = 3, col.sub = "red", xlab = "Petal Length", ylab = "Petal Width",
      line = NA, outer = FALSE)

# What does the below code do
par(mfrow = c(1,2))
plot(iris$Petal.Length, iris$Petal.Width, col = iris$Species, main = "iris", xlab = "Petal Length", ylab = "Petal Width")
plot(iris$Sepal.Length, iris$Sepal.Width, col = iris$Species, main = "iris", xlab = "Sepal Length", ylab = "Sepal Width")
