##Simulate and test autocorrelations
#set seed
set.seed(12312025) #reproducibility

#Parameters for simulating from AR(1)
n <- 200
theta <- 0.8

#Simulate MA(1): X_t = e_t + theta * e_{t-1} 
e <- rnorm(n + 1, 0, 1) #e is Gaussian white noise
X <- e[-1] + theta * e[-(n + 1)]

#Compute sample autocorrelations
acf(X) # plot ACF
r <- acf(X, plot = FALSE)$acf[-1]  # remove lag 0

#Test statistic under H0: rho_k = 0 
#assuming X_t is coming from white noise
Z.stat <- sqrt(n) * r

#Critical value (z_{alpha/2}) from standard normal
alpha = 0.05
z.crit <- qnorm(1 - alpha / 2)
print(z.crit)

#Decision rule: reject H0 if |Z| > z_{alpha/2}
reject <- abs(Z.stat) > z.crit

# Display results
data.frame(
  Lag = 1:length(r),
  ACF = round(r, 3),
  Z.stat = round(Z.stat, 3),
  z.crit = round(z.crit, 3),
  Reject.H0 = reject
)

##how do I test for MA(1)?
