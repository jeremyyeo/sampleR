# nnet example
library(nnet)
library(caret)

# One off example ----
set.seed(1234)

iris_shuffled <- iris[sample(nrow(iris)), ]
split      <- floor(nrow(iris_shuffled)/2)
iris_train <- iris_shuffled[0:split, ]
iris_test  <- iris_shuffled[(split+1):nrow(iris_shuffled), ]

# Build prediction model
species_model <- multinom(Species ~., data = iris_train, maxit = 500, trace = T)

# Examine most important variables
most_important_vars <- varImp(species_model)

# Predict
predict_species <- predict(species_model, type = "class", newdata = iris_train)

# Check accuracy
postResample(iris_test$Species, predict_species)

# Cross Validation ----
total_accuracy <- c()
cv <- 10
cv_divider <- floor(nrow(iris_shuffled) / (cv + 1))

for (cv in seq(1:cv)) {
  # assign chunk to data test
  dataTestIndex <- c((cv * cv_divider):(cv * cv_divider + cv_divider))
  dataTest <- iris_shuffled[dataTestIndex, ]
  # everything else to train
  dataTrain <- iris_shuffled[-dataTestIndex,]
  
  cylModel <- multinom(Species ~ ., data=dataTrain, maxit = 50, trace = F) 
  
  pred <- predict(cylModel, newdata = dataTest, type = "class")
  
  #  classification error
  cv_ac <- postResample(dataTest$Species, pred)[[1]]
  print(paste('Current Accuracy:',cv_ac,'for CV:',cv))
  total_accuracy <- c(total_accuracy, cv_ac)
}

mean(total_accuracy)
