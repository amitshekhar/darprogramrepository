# 1. MLR: mpg ~ all other variables
m1 = lm(mpg~., data = mtcars)
summary(m1) # Multiple R-squared:  0.869,	Adjusted R-squared:  0.8066

# 2. Add a totally randomly generated independent variable
mtcars$random_var = sample(1:100, nrow(mtcars), replace = T) 

# 3. Build a model and compare the R squared and adjusted R squared
m2 = lm(mpg~., data = mtcars)
summary(m2) # Multiple R-squared:  0.8943,	Adjusted R-squared:  0.8362 
# Multiple R-squared:  0.8901,	Adjusted R-squared:  0.8296(after 5 times)
