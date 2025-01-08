# loading libraries
library(MASS)

# dataset
df <- Boston
View(df)

plot(y = df$medv, x = df$lstat)

dim(df)

model <- lm(df$medv ~ df$lstat)
summary(model)

y_estimate <- predict(model, newdata = data.frame(df$lstat))
MSE <- mean((y_estimate - df$medv)^2)
print("Mean Squared Error:")
MSE

print("Confindence intervals for parameters")
confint(object = model)

names(model)

x_test <- data.frame(c(5, 10, 15))
y6 <- model$coefficients[1] + model$coefficients[2] * x_test
print("prediction of 5, 10, 15")
y6

# Q2
attach(df)
colnames(df)

lmodel <- lm(medv ~ ., data = df)
summary(model)

# LOOCV
n <- dim(df)[1]
medv.pred <- numeric(n)
test.error <- numeric(n)

for (i in 1:n) {
    x_train <- df[-i, ]

    fit.train <- lm(medv ~ ., data = x_train)
    medv.pred[i] <- predict(fit.train, newdata = df[i, -14])
    test.error[i] <- (medv[i] - medv.pred[i])^2
}
medv.pred
test.error

# K-fold cross validation
set.seed(1)
permutation <- sample(1:n, replace = FALSE)
k <- 4

test.index <- split(permutation, rep(1:k, length = n, each = n / k))
test.index

for (i in 1:k) {
    test.indices <- test.index[[i]]
    x_train <- df[-(test.indices), ]

    fit.train <- lm(medv ~ ., data = x_train)
    medv.pred[test.indices] <- predict(fit.train, newdata = df[test.indices, -14])
    test.error[test.indices] <- (medv[test.indices] - medv.pred[test.indices])^2
}
medv.pred
test.error
mean(test.error)

# Bootstrap
B <- 1000
boot <- numeric(b)

for (b in 1:B) {
    foo <- sample(1:n, size = n, replace = TRUE)
    boot.samp <- df[foo, ]

    model <- lm(m)
}
