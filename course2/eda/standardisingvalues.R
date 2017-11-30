# TODO
# Write a function which identifies and removes the "*" character after some numeric values in a vector.
# Make sure that the resultant vector is a numeric vector.


remove_string <- function(vector){
  # store the resulting vector in corrected_vector
  # write all your code here
  #?gsub
  corrected_vector <- as.numeric(gsub("\\*", "", vector))
    
    #---DO NOT EDIT THE CODE BELOW---#
    return(corrected_vector)
}


# Test - Passing a vector - c(21,34,99*,56,90*, 45*), to your function
remove_string(c(21,34,"99*",56,"90*", "45*"))
# The ideal output should be numeric and look like: 21 34 99 56 90 45
