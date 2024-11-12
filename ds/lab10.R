# installing libraries
# install.packages("caTools")
# install.packages("nnet")
library(caTools)
library(nnet)

# dataset
df <- iris

# test train split
split <- sample.split(df$Species, SplitRatio = 0.7)
# this returns a vector of true or false
train_set <- subset(df, split == "TRUE")
test_set <- subset(df, split == "FALSE")

# Perform feature scaling (Normalisation)
train_scale <- data.frame(scale(train_set[, 1:4]))
test_scale <- data.frame(scale(test_set[, 1:4]))
train_scale$Species <- train_set$Species
test_scale$Species <- test_set$Species

# Fitting Multinomial Logistic Regression Model
set.seed(12) # Setting Seed
model <- nnet::multinom(Species ~ ., data = train_scale)
model

# Predicting the values for train dataset
predictions <- predict(model, type = "class", newdata = test_scale)
predictions

# exercises
# confusion matrix
confusion_matrix <- table(original = test_set$Species, predicted = predictions)
confusion_matrix

# classification accuracy
total <- nrow(test_set)
true_positive <- 0
for (i in 1:3) {
  true_positive <- true_positive + confusion_matrix[i, i]
}

classification_accuracy <- true_positive / total

# precision for virginica
TP_virginica <- confusion_matrix[3, 3]
FP_virginica <- confusion_matrix[1, 3] + confusion_matrix[2, 3]
precision_virginica <- TP_virginica / (TP_virginica + FP_virginica)

# recall for versicolor
TP_versicolor <- confusion_matrix[2, 2]
FN_versicolor <- confusion_matrix[2, 1] + confusion_matrix[2, 3]
recall_versicolor <- TP_versicolor / (TP_versicolor + FN_versicolor)

# f1 score iris verginica
TP_vergin <- confusion_matrix[3, 3]
FN_vergin <- confusion_matrix[3, 1] + confusion_matrix[3, 2]
recall_vergin <- TP_vergin / (TP_vergin + FN_vergin)
f1_vergin <- 2 * recall_vergin * precision_virginica / (recall_vergin + precision_virginica)
