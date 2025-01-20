# setting seed for reproducibility
set.seed(1)

# Parameters
n <- 100 # parameter n
p <- 1 / 4 # parameter p
num_samples <- 10000 # Number of samples to simulate

# Binomial PMF
binomial_pmf <- function(k, n, p) {
    choose(n, k) * (p^k) * ((1 - p)^(n - k))
}

# Geometric PMF
geometric_pmf <- function(k, p) {
    ((1 - p)^k) * p
}

# Compute the scaling constant c
k_values <- 0:n
f_values <- binomial_pmf(k_values, n, p)
g_values <- geometric_pmf(k_values, p)
c <- max(f_values / g_values)

# Simulate Accept-Reject Sampling
accepted <- 0

for (i in 1:num_samples) {
    # Propose a sample from the geometric distribution
    k <- rgeom(1, p) # Geometric sampling (0-based index)

    # Reject samples outside the binomial support
    if (k > n) next

    # Accept with probability f(k) / (c * g(k))
    accept_prob <- binomial_pmf(k, n, p) / (c * geometric_pmf(k, p))
    # runif (1) draws u from u(0,1)
    if (runif(1) < accept_prob) {
        accepted <- accepted + 1
    }
}

# Compute efficiency
efficiency <- accepted / num_samples

# Results
cat("Scaling constant (c):", c, "\n")
cat("Efficiency of the algorithm:", efficiency, "\n")
