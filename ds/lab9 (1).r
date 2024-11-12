#loading data set
df = iris
attach(df)

#plotting all the variables to check which has the best clusters
plot(Sepal.Length, Sepal.Width, col=Species)
plot(Sepal.Length, Petal.Length, col=Species)
plot(Sepal.Length, Petal.Width, col=Species)
plot(Sepal.Width, Petal.Width, col=Species)
plot(Sepal.Width, Petal.Length, col=Species)
plot(Petal.Length, Petal.Width, col=Species)
#the plot of petal length and petal width is very easy to identify clusters
#we will use petal length and petal width

# setting seed
set.seed(10)
sample=df[sample(1:nrow(df)), ]
attach(sample)

#test train split
x_train=sample[1:120, c("Petal.Length","Petal.Width")]
y_train=sample[1:120, "Species"]
x_test=sample[121:150, c("Petal.Length","Petal.Width")]
y_test=sample[121:150, "Species"]

# defining some functions
find_dist= function(a1, b1, a2, b2){
  return ((a1-a2)*(a1-a2)+(b1-b2)*(b1-b2))
}

find_min=function(distances, k){
  min=1
  for (i in 1:k) {
    if(distances[min]>distances[i]){
      min=i
    }
  }
  return (min)
}

#k means clustering
k=3

k_means <- function(data, y, k, max_iter = 100, tol = 1e-4) {
  
  # Convert data to numeric matrix
  data <- as.matrix(data)
  
  # Initialize centroids by selecting one random point from each class (species)
  unique_classes <- unique(y)
  centroids <- matrix(NA, nrow = k, ncol = ncol(data))  # Initialize the centroids matrix
  for (i in 1:k) {
    class_data <- data[y == unique_classes[i], ]  # Subset the data for the current class
    centroids[i, ] <- class_data[sample(1:nrow(class_data), 1), ]  # Randomly pick one point from the class
  }
  
  # Iteratively update clusters and centroids
  for (i in 1:max_iter) {

    #Assign each point to the nearest centroid
    clusters <- numeric(nrow(data))
    for (j in 1:nrow(data)) {
      dists <- numeric(k)  # Create a vector to store distances to all centroids
      for (m in 1:k) {
        dists[m] <- find_dist(centroids[m, 1], centroids[m, 2], data[j, 1], data[j, 2])
      }
      clusters[j] <- find_min(dists, k)  # Assign to the closest centroid
    }
    
    # Recalculate centroids by computing the mean of points in each cluster
    new_centroids <- matrix(NA, nrow = k, ncol = ncol(data))
    for (l in 1:k) {
      new_centroids[l, ] <- colMeans(data[clusters == l, , drop = FALSE])  # Mean of all points in cluster l
    }
    
    # Check if centroids don't change much
    centroid_shift <- sum(apply((new_centroids - centroids)^2, 1, sum))
    if (centroid_shift < tol) {
      break  # If the centroids have shifted little, the algorithm has converged
    }
    
    centroids <- new_centroids  # Update centroids for the next iteration
  }
  
  return (centroids)
}


result <- k_means(x_train, y_train, k)

# Viewing results
result

# Function to assign each test point to the nearest centroid
predict_clusters <- function(test_data, centroids, k) {
  clusters <- numeric(nrow(test_data))  # Vector to store cluster assignments for test data
  for (i in 1:nrow(test_data)) {
    dists <- numeric(k)  # Vector to store distances to all centroids
    for (j in 1:k) {
      dists[j] <- find_dist(centroids[j, 1], centroids[j, 2], test_data[i, 1], test_data[i, 2])
    }
    clusters[i] <- which.min(dists)  # Assign to the closest centroid
  }
  return(clusters)
}

# Map clusters to species using the closest 3 points in the training data to the centroid
map_clusters_to_species <- function(clusters, centroids, x_train, y_train, k) {
  cluster_to_species <- character(k)  # To store the most frequent species for each cluster
  
  # For each cluster, find the 3 nearest points in the training set and get their species
  for (i in 1:k) {
    # Find distances between the current centroid and all training points
    dists <- apply(x_train, 1, function(point) find_dist(centroids[i, 1], centroids[i, 2], point[1], point[2]))
    
    # Get the indices of the 3 nearest points to the centroid
    nearest_indices <- order(dists)[1:3]  # Indices of the 3 closest points
    
    # Get the species of these 3 closest points
    closest_species <- y_train[nearest_indices]
    
    # Find the most frequent species among the 3 closest points
    most_common_species <- names(sort(table(closest_species), decreasing = TRUE)[1])
    
    # Assign the most frequent species to this cluster
    cluster_to_species[i] <- most_common_species
  }
  
  return(cluster_to_species)
}

# Create confusion matrix
confusion_matrix <- function(predictions, true_labels) {
  table(predictions, true_labels)  # Compare predicted clusters to true labels
}

# Assign clusters to the test set using the centroids from the training set
predicted_clusters <- predict_clusters(x_test, result, k)

# 2. Map the predicted clusters to species names using the 3 closest points in the training set
cluster_to_species_mapping <- map_clusters_to_species(predicted_clusters, result, x_train, y_train, k)

# 3. Map the predicted clusters to species using the cluster-to-species mapping
predicted_species <- cluster_to_species_mapping[predicted_clusters]

# 4. Create the confusion matrix
conf_matrix <- confusion_matrix(predicted_species, y_test)

# Display confusion matrix
print(conf_matrix)
