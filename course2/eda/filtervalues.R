# TO-DO
# some_df is a dataframe which may contain duplicate rows
# Complete the function such that it returns a dataframe after removing them from some_df

remove_dup <- function(some_df){
  # remove duplicate values from some_df and store the resulting dataframe in new_df
  
  # Please enter your code below
  
  new_df <- which(duplicated(remove_dup))
    
    
    
    #---DO NOT EDIT THE CODE BELOW---#
    return(new_df)
}


# Passing a dataframe - data.frame(rbind(c(2,9,6),c(4,6,7),c(4,6,7),c(4,6,7),c(2,9,6))), to your function
remove_dup(data.frame(rbind(c(2,9,6),c(4,6,7),c(4,6,7),c(4,6,7),c(2,9,6))))
# The ideal output is:   X1 X2 X3
#                      1  2  9  6
#                      2  4  6  7
