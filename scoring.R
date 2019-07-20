#############
# Functions #
#############

# Necessary libraries
library(dplyr)

# Generate a score based on votes from users
# Desc: Compute votes in object divided by All votes,
# after that compute positive votes minus negative votes divided by maybe votes squared.
# score should be both values multiplied. Rescaling from range zero to three.
itemScore <- function(table){
  perObject <- table$votes
  totalObject <- sum(perObject)
  # Score Factors
  importance = (perObject+1)/(totalObject+1)
  #consistence = 1**(((table[,5]-table[,7]+1))/((table[,6]**2+1)))
  consistence = ((table[,5]+1)/(table[,7]+1))*(1+1/(table[,6]+1))
  score <- importance*consistence
  #score <- scales::rescale(score, to = c(0,3))
  return(score)
}

# Generate a score based on mean values of a object based on values of that object inside a class.
# Desc: Priority is based on disparate that object price is compared to mean object value
# and how much that object itemScore is.
priorityScore <- function(table){
  table <- as.data.frame(table %>%
                  group_by(category) %>%
                  mutate(weight = median(unit_price, na.rm = T), size = n(), discrep = (unit_price-weight)/weight))
  table$score = itemScore(table)
  priority = table$discrep * table$score
  return(priority)
}






