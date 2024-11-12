# loading dataset
df <- iris

# normalising the data
min_max_norm <- function(x) {
  (x - min(x)) / (max(x) - min(x))
}

df <- as.data.frame(lapply(df[1:4], min_max_norm))
# taking only x values to simulate unsupervised data for unsupervised algo

# creating data matrix
X <- as.matrix(df)

# creating mean matrix
# t means transpose
mu <- colMeans(X)
M <- matrix(data = 0, nrow = nrow(X), ncol = ncol(X))
for (row in 1:dim(X)[1]) {
  M[row, ] <- mu
}
mu
M
# subtracting mean matrix
X_ <- X - M
# covariance matrix
C <- cov(X_)

# eigen vectors and values
e <- eigen(C)

Eigenvectors <- e$vectors
Eigenvalues <- e$values

# finding percent proportions of data
percent_proportion <- 100 * Eigenvalues / sum(Eigenvalues)
barplot(percent_proportion, names.arg = c("v1", "v2", "v3", "v4"))

# reducing dimensions
reduced_data <- Eigenvectors[1:2, ] %*% t(X_)
plot(x = reduced_data[1, ], y = reduced_data[2, ])
reduced_data
Eigenvectors







# exploring mtcars
# loading dataset
df <- mtcars
# mazda 1
# corolla 20
# fiat 18

df <- as.data.frame(lapply(df[2:11], min_max_norm))
# taking only x values to simulate unsupervised data for unsupervised algo

# creating data matrix
X <- as.matrix(data.frame(df))

# creating mean matrix
# t means transpose
mu <- matrix(c(rowSums(t(X)) / dim(X)[1]))
mu <- t(mu)
M <- matrix(data = 0, nrow = dim(X)[1], ncol = dim(X)[2])
for (row in 1:dim(X)[1]) {
  for (col in 1:dim(X)[2]) {
    M[row, col] <- mu[col]
  }
}

# subtracting mean matrix
X_ <- X - M
# covariance matrix
C <- t(X_) %*% X_

# eigen vectors and values
e <- eigen(C)

Eigenvectors <- e$vectors
Eigenvalues <- e$values

# finding percent proportions of data
percent_proportion <- 100 * Eigenvalues / sum(Eigenvalues)
barplot(percent_proportion)

# reducing dimensions
reduced_data <- Eigenvectors[1:2, ] %*% t(X_)
plot(x = reduced_data[1, ], y = reduced_data[2, ])

# finding out for the given cars
required_cars <- reduced_data[, c(1, 18, 20)]
plot(x = required_cars[1, ], y = required_cars[2, ], col = c("red", "blue", "green"))

# mazda RX4 is closer to Toyota corolla than fiat 128
