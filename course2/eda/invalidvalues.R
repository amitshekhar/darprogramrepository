# TODO
# Write a function which takes a vector of marks and replaces every value above 100 with NA

remove_invalid <- function(marks_vector){
  # store the resulting vector in Corrected_marks
  # Please enter your code below
  
  marks_vector[which(marks_vector > 100)]<- NA
  corrected_marks <-as.numeric(marks_vector)
  
  
    
    
    #---DO NOT EDIT THE CODE BELOW---#
    return(corrected_marks)
}


# Test - Passing a vector - c(89, 90, 108, 56), to your function
remove_invalid(c(89, 90, 108, 56))
# The ideal output should look like: 89 90 NA 56
