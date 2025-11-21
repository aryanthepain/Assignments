#set seed (reproducibility)
set.seed(2025)

#call the libraries that are needed
#install before if not there already
library(ggplot2)

#parameters for AR(1)
phi <- 0.6     #AR coeff
n <- 200       #data size

#simulate stationary AR(1) process
y <- arima.sim(model = list(ar = phi), n = n)

#fit AR(1) model to simulated data
fit <- arima(y, order = c(1, 0, 0))
fit

#compute the fitted values
phi_hat <- fit$coef["ar1"]
fitted_vals <- c(NA, phi_hat * y[-length(y)])

#create data frame for ggplot
df <- data.frame(
  time = 1:n,
  Simulated = as.numeric(y),
  Fitted = as.numeric(fitted_vals)
)

#plot simulated and fitted series together
ggplot(data = df, aes(x = time)) +
  geom_line(aes(y = Simulated, colour = "Simulated Data"), linewidth = 0.5) +
  geom_line(aes(y = Fitted, colour = "Fitted Values"), linewidth = 0.5, linetype = "dashed") +
  scale_colour_manual(
    name = NULL,
    values = c("Simulated Data" = "#40826D",   
               "Fitted Values"  = "#8FD9B6")) +
  labs( x = "Time", y = "Simulated and fitted data") +
  theme_minimal(base_size = 10) +
  theme(legend.position = "top")

#extract residuals from fit
res <- residuals(fit)

# Create data frame for ggplot
res_df <- data.frame(
  time = 1:length(res),
  residuals = as.numeric(res)
)

#run sequence plot
ggplot(res_df, aes(x = time, y = residuals)) +
  geom_line(colour = "#40826D", linewidth = 0.9) +
  geom_hline(yintercept = 0, linetype = "dashed", colour = "gray40") +
  labs(x = "Time",y = "Residuals") +
  theme_minimal(base_size = 10)

#lag plot
# Create lagged residuals
e_t <- res[-1]
e_t_minus1 <- res[-length(res)]

# Combine into a data frame
lag_df <- data.frame(
  e_t = e_t,
  e_t_minus1 = e_t_minus1
)
ggplot(lag_df, aes(x = e_t_minus1, y = e_t)) +
  geom_point(colour = "#40826D", alpha = 0.7, size = 2) +
  labs(x = expression(e[t-1]), y = expression(e[t])) +
  theme_minimal(base_size = 10)

#ACF plot
acf(res, main = "ACF of Residuals", col = "#40826D")

#histogram 
hist(res,
     breaks = 20,
     main = "Histogram of Residuals",
     xlab = "Residuals",
     col = "#40826D",
     border = "white")

#QQ plot
qqnorm(res,
       main = "QQ Plot of Residuals",
       col = "#40826D")
qqline(res, col = "gray40", lwd = 2, lty = 2)

# Box–Pierce test
bp_test <- Box.test(res, lag = 10, type = "Box-Pierce")

# Ljung–Box test
lb_test <- Box.test(res, lag = 10, type = "Ljung-Box")

