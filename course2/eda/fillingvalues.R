# TO-DO
# Write a function which identifies blank characters representing the unavailable values, and replaces them with NA 
# Make sure that the resultant vector is a numeric vector
# Consider these as blank values :  " ", "", "-"

remove_blank <- function(vector){
  # store the resulting vector in corrected_vector
  # Please enter your code below
  
  vector[which(vector == "-"| vector == ""|vector == " ")]<- NA
  corrected_vector <- as.numeric(vector)
  
  #---DO NOT EDIT THE CODE BELOW---#
  return(corrected_vector)
}

# Test - Passing c(21,""," " ,34,"-",78, 98) to your function
remove_blank(c(21,""," " ,34,"-",78, 98))
# The ideal output should look like: 21 NA NA 34 NA 78 98