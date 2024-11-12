set.seed(10)
x <- seq(-5, 5, 1)
x <- sample(x)
y <- -150 + 2 * x + 3 * x**2
y <- y + c(0, 0, 0, 50, 0, 0, 0, 0, 0, 0, 0)
x_train <- x[1:8]
y_train <- y[1:8]
x_test <- x[9:11]
y_test <- y[9:11]

# plotting
plot(x_train, y_train, main = "training data")
plot(x_test, y_test, main = "test data")







# regression without bias
model <- lm(y_train ~ x_train - 1)

# predict data
y_pred <- predict(model, newdata = data.frame(x_train = x_test))

# report performance
mse <- mean((y_test - y_pred)^2)
mse

# plot
y_min <- min(c(y_test, y_pred)) - 10

y_max <- max(c(y_test, y_pred)) + 10

plot(x_test, y_pred,
       main = "Actual vs Predicted",
       xlab = "x_test",
       ylab = "y",
       pch = 19,
       col = "blue",
       type = "b",
       ylim = c(y_min, y_max)
)

points(x_test, y_test,
       col = "red",
       type = "b",
       pch = 19
)

legend("bottomleft",
       legend = c("Actual", "Predicted"),
       col = c("red", "blue"),
       pch = c(19, 19)
)







# regression with bias
model <- lm(y_train ~ x_train)

# predict data
y_pred <- predict(model, newdata = data.frame(x_train = x_test))

# report performance
mse <- mean((y_test - y_pred)^2)
mse

# plot
y_min <- min(c(y_test, y_pred)) - 10
y_max <- max(c(y_test, y_pred)) + 10

plot(x_test, y_pred,
       main = "Actual vs Predicted",
       xlab = "x_test",
       ylab = "y",
       pch = 19,
       col = "blue",
       type = "b",
       ylim = c(y_min, y_max)
)


points(x_test, y_test,
       col = "red",
       type = "b",
       pch = 19
)


legend("topright",
       legend = c("Actual", "Predicted"),
       col = c("red", "blue"),
       pch = c(19, 19)
)






# mtcars
data("mtcars")
df <- mtcars
attach(df)

# splitting data
dim(df)
train_indices <- sample(1:nrow(mtcars), size = 0.7 * nrow(mtcars))

# Create training and testing sets
train_set <- mtcars[train_indices, ]
test_set <- mtcars[-train_indices, ]

model <- lm(mpg ~ hp + wt + cyl + carb, data = train_set)
coefficients(model)

# predict data
y_pred <- predict(model, test_set)

# report performance
mse <- mean((test_set$mpg - y_pred)^2)
mse






# Polynomial regression with validation set
set.seed(123) # For reproducibility
x <- seq(-5, 5, 1)
x <- sample(x)
y <- -150 + 2 * x + 3 * x^2
y <- y + c(0, 0, 0, 50, 0, 0, 0, 0, 0, 0, 0)

# Split data into training, validation, and test sets
train_indices <- sample(1:length(x), size = 0.6 * length(x)) # 60% for training
remaining_indices <- setdiff(1:length(x), train_indices)

validation_indices <- sample(remaining_indices, size = 0.2 * length(x)) # 20% for validation
test_indices <- setdiff(remaining_indices, validation_indices) # 20% for testing

x_train <- x[train_indices]
y_train <- y[train_indices]
x_val <- x[validation_indices]
y_val <- y[validation_indices]
x_test <- x[test_indices]
y_test <- y[test_indices]

# Train the model using the training set
model <- lm(y_train ~ x_train + I(x_train^2))

# Validate the model using the validation set
y_val_pred <- predict(model, newdata = data.frame(x_train = x_val))

# Report validation performance
val_mse <- mean((y_val - y_val_pred)^2)
cat("Validation MSE:", val_mse, "\n")

# Test the model using the test set
y_test_pred <- predict(model, newdata = data.frame(x_train = x_test))

# Report test performance
test_mse <- mean((y_test - y_test_pred)^2)
cat("Test MSE:", test_mse, "\n")

# Plot predictions
y_min <- min(c(y_test, y_test_pred)) - 10
y_max <- max(c(y_test, y_test_pred)) + 10

plot(x_test, y_test_pred,
       main = "Actual vs Predicted",
       xlab = "x_test",
       ylab = "y",
       pch = 19,
       col = "blue",
       ylim = c(y_min, y_max)
)

points(x_test, y_test,
       col = "red",
       pch = 19
)

legend("bottomleft",
       legend = c("Actual", "Predicted"),
       col = c("red", "blue"),
       pch = c(19, 19)
)

# Initialize a vector to store MSE values for different polynomial degrees
mse_values <- numeric(5)

# Loop over polynomial degrees from 1 to 6
for (p in 1:5) {
       model <- lm(y_train ~ poly(x_train, p))
       y_val_pred <- predict(model, newdata = data.frame(x_train = x_val))
       mse_values[p] <- mean((y_val - y_val_pred)^2)
       cat("Degree:", p, "Validation MSE:", mse_values[p], "\n")
}

# Report the best polynomial degree based on validation set
best_p <- which.min(mse_values)
cat("Best polynomial degree:", best_p, "with Validation MSE:", mse_values[best_p], "\n")

# For the best polynomial degree, evaluate on test set
x_train <- c(x_train, x_val)
y_train <- c(y_train, y_val)
final_model <- lm(y_train ~ poly(x_train, 2))
y_test_pred <- predict(final_model, newdata = data.frame(x_train = x_test))
final_test_mse <- mean((y_test - y_test_pred)^2)
cat("Final Test MSE for best degree:", final_test_mse, "\n")
