# install.packages("ggplot2")  # Uncomment if ggplot2 is not installed
library(ggplot2) # Create a sample dataset
set.seed(123) # For reproducibility
data <- data.frame(
    x = rnorm(100),
    y = rnorm(100)
)
df <- iris
data <- df[, 3:4]
# Set the number of clusters
k <- 3

# Run K-means clustering
kmeans_result <- kmeans(data, centers = k, nstart = 25)

# View the results
# print(kmeans_result)# Set the number of clusters
data$cluster <- as.factor(kmeans_result$cluster)

# Plot the clusters
ggplot(data, aes(x = Petal.Length, y = Petal.Width, color = cluster)) +
    geom_point(size = 10) +
    labs(title = "K-means Clustering", x = "X-axis", y = "Y-axis") +
    theme_minimal()
