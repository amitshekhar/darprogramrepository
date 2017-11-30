# Simple Linear regression 

#Importing dataset in R 
radiomarketing <- read.csv("radiomarketing.csv")

# Now let's check the structure of advertising dataset. 
# structure of dataset

str(radiomarketing)


# Let's quickly look at the plot of sales and Radio spend
plot(radiomarketing$Radio, radiomarketing$Sales)


### So set the seed to 100, let's run it 
set.seed(100)

#### You can use sample function for getting the indices of your 70% of observations. 
#### Let's execute this commad. 

trainindices= sample(1:nrow(newspapermarketing), 0.7*nrow(newspapermarketing))

### Now create an object "train.advertising" and store the 70% of the data of housing dataset 
# by just passing the indices inside the housing dataset

train.radiomarketing = radiomarketing[trainindices,]


### Similarly store the rest of the observations into an object "test".
### Let's execute both train and test commands

test = radiomarketing[-trainindices,]





model<-lm(Sales~Radio,data = train.radiomarketing)

# The model is stored as an object in the variable 'model' 
# Now, we want to check the summary to analyse the results of the model using summary (model).

summary(model)

# A lot of information is popped by just checking the summary, 




# Now, execute this command
Predict_1 <- predict(model, test[-2])

##Next, append the predicted results with the test data set 
# to compare the actual prices with the predicted ones

test$test_sales <- Predict_1


r <- cor(test$Sales,test$test_sales)
rsquared <- r^2
rsquared #0.2862187
