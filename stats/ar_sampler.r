set.seed(1) # for reproducibility

# Parameters
n <- 100 # Number of trials in the Binomial distribution
p <- 1 / 4 # Success probability in the Binomial distribution
num_samples <- 10000 # Number of samples to draw

# Binomial PMF
binomial_pmf <- function(k, n, p) {
    choose(n, k) * (p^k) * ((1 - p)^(n - k))
}

# Proposal distributions
geometric_pmf <- function(k, q) {
    if (k < 0) {
        return(0)
    } # Geometric is only defined for k >= 0
    ((1 - q)^k) * q
}

poisson_pmf <- function(k, lambda) {
    if (k < 0) {
        return(0)
    } # Poisson is only defined for k >= 0
    (lambda^k * exp(-lambda)) / factorial(k)
}

normal_pdf <- function(k, mean, sd) {
    dnorm(k, mean = mean, sd = sd)
}

# Accept-Reject Sampling for the Geometric Proposal
q <- 1 / 4 # Geometric success probability
c_geometric <- max(binomial_pmf(0:n, n, p) / geometric_pmf(0:n, q))
accepted_geometric <- 0

for (i in 1:num_samples) {
    k <- rgeom(1, q) # Draw a sample from the geometric distribution
    if (k <= n) { # Ensure k is within the support of Binomial(n, p)
        accept_prob <- binomial_pmf(k, n, p) / (c_geometric * geometric_pmf(k, q))
        if (runif(1) < accept_prob) {
            accepted_geometric <- accepted_geometric + 1
        }
    }
}
efficiency_geometric <- accepted_geometric / num_samples

# Accept-Reject Sampling for the Poisson Proposal
lambda <- n * p # Poisson mean approximates Binomial mean
c_poisson <- max(binomial_pmf(0:n, n, p) / poisson_pmf(0:n, lambda))
accepted_poisson <- 0

for (i in 1:num_samples) {
    k <- rpois(1, lambda) # Draw a sample from the Poisson distribution
    if (k <= n) { # Ensure k is within the support of Binomial(n, p)
        accept_prob <- binomial_pmf(k, n, p) / (c_poisson * poisson_pmf(k, lambda))
        if (runif(1) < accept_prob) {
            accepted_poisson <- accepted_poisson + 1
        }
    }
}
efficiency_poisson <- accepted_poisson / num_samples

# Accept-Reject Sampling for the Normal Proposal
mean <- n * p
sd <- sqrt(n * p * (1 - p))
c_normal <- max(binomial_pmf(0:n, n, p) / normal_pdf(0:n, mean, sd))
accepted_normal <- 0

for (i in 1:num_samples) {
    k <- round(rnorm(1, mean = mean, sd = sd)) # Draw a sample from the Normal distribution and round to integer
    if (k >= 0 && k <= n) { # Ensure k is within the support of Binomial(n, p)
        accept_prob <- binomial_pmf(k, n, p) / (c_normal * normal_pdf(k, mean, sd))
        if (runif(1) < accept_prob) {
            accepted_normal <- accepted_normal + 1
        }
    }
}
efficiency_normal <- accepted_normal / num_samples

# Results
cat("Efficiency of the geometric proposal:", efficiency_geometric, "\n")
cat("Efficiency of the Poisson proposal:", efficiency_poisson, "\n")
cat("Efficiency of the Normal proposal:", efficiency_normal, "\n")
