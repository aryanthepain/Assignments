# importing libraries
# install.packages("ggplot2")
# install.packages("dplyr")
# library(ggplot2)
# library(dplyr)

# generating data
set.seed(10)
x <- seq(-5, 5, 1)
x <- sample(x)
y <- -80 + 4 * x + 2 * x**2
y <- y + c(0, 0, 0, 0, 0, 50, 0, 0, 0, 0, 0)
x_train <- x[1:8]
y_train <- y[1:8]
x_test <- x[9:11]
y_test <- y[9:11]

# (a)
# a1
plot(x_train, y_train)
# a2
plot(x_test, y_test)

# (b)
# b1
x_train_df <- as.data.frame(x_train)
x_train_df <- cbind(x_train_df, x_train**2)
x_train_df <- cbind(x_train_df, 1)

x_test_df <- as.data.frame(x_test)
x_test_df <- cbind(x_test_df, x_test**2)
x_test_df <- cbind(x_test_df, 1)

model <- lm.fit(as.matrix(x_train_df), y_train)
model$coefficients

# b2
y_pred <- 0
for (i in 1:3) {
    for (j in 1:3) {
        y_pred <- y_pred + model$coefficients[j] * x_test_df[j]
    }
}

y_pred_arr <- c()
for (i in 1:3) {
    y_pred_arr <- c(y_pred_arr, y_pred[i, 1])
}
y_pred <- y_pred_arr

# b3
mse <- (y_pred - y_test)^2
mse <- sum(mse) / 3
print(mse)

ggplot() +
    geom_line(mapping = aes(x = x_test, y = y_test, colour = "original")) +
    geom_line(mapping = aes(x = x_test, y = y_pred, colour = "predicted")) +
    labs(title = "Predicted VS Original", x = "x", y = "y") +
    theme_minimal()
