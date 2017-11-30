# To-DO
# Complete the function which takes in a vector & replaces the phone numbers not having exactly 10 digits with NA

phone <- function(phone_vector){
  
  # Store the cleaned vector in clean_vector
  # Please enter your code below
  
  invalid <- which(nchar(as.character(phone_vector))!= 10)
  phone_vector[invalid] <- NA
  clean_vector <- phone_vector
    
    #---DO NOT EDIT THE CODE BELOW---#
    return(clean_vector)
}

# Test - Passing a vector - c(99887766, 998877665521, 9897932453) to your function
phone(c(99887766, 998877665521, 9897932453))
# The ideal output should look like: NA NA 9897932453
