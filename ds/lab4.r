# importing libraries
# install.packages("ggplot2")
library("ggplot2")
# install.packages("dplyr")
library("dplyr")

# importing data
?diamonds
colnames(diamonds)
nrow(diamonds)

# sampling data, because og data is too large
df <- sample_n(diamonds, 1000)
attach(df)

# plots, this will only add a layer and not plot any data
ggplot(data = df)
# point plot
# aes=aesthetic plotting
ggplot(data = df) +
  geom_point(mapping = aes(x = carat, y = price))

# color
ggplot(data = df) +
  geom_point(mapping = aes(x = carat, y = price, color = clarity))

# cut
ggplot(data = df) +
  geom_point(mapping = aes(x = carat, y = price, shape = cut))

# size
ggplot(data = df) +
  geom_point(mapping = aes(x = carat, y = cut, size = price))

# line plot
ggplot(data = df) +
  geom_line(mapping = aes(x = carat, y = price, color = cut))

# smooth plot
ggplot(data = df) +
  geom_smooth(mapping = aes(x = carat, y = price, color = cut))

# bar graph, column plot
ggplot(data = df) +
  geom_col(mapping = aes(x = cut, y = price)) # this will give total value though
ggplot(data = df) +
  geom_col(mapping = aes(x = cut, y = price, fill = clarity))

# multi plot
ggplot(data = df) +
  geom_point(mapping = aes(x = carat, y = price, color = cut), aplha = 0.3) +
  geom_smooth(mapping = aes(x = carat, y = price, color = cut), se = FALSE)
# se means standard error


# assignment
ggplot(data = df) +
  geom_boxplot(mapping = aes(y = price, x = color))
# log function
ggplot(data = df) +
  geom_boxplot(mapping = aes(y = price, x = color)) +
  scale_y_log10()

# violin plot
ggplot(data = df) +
  geom_violin(mapping = aes(y = price, x = color)) +
  scale_y_log10()

# heatmap
ggplot(data = df) +
  geom_bin_2d(mapping = aes(y = price, x = carat))
ggplot(data = df) +
  geom_bin_2d(mapping = aes(y = price, x = carat)) +
  scale_y_log10() +
  scale_x_log10()

ggplot(data = iris) +
  geom_point(mapping = aes(y = Sepal.Length, x = Sepal.Width))

colnames(mtcars)
attach(mtcars)
average <- aggregate(mpg ~ cyl, data = mtcars, FUN = mean)
ggplot(data = average) +
  geom_col(mapping = aes(y = mpg, x = cyl))

colnames(ChickWeight)
attach(ChickWeight)
ggplot(data = ChickWeight) +
  geom_line(mapping = aes(y = weight, x = Time, color = Chick))

colnames(ToothGrowth)
attach(ToothGrowth)
ggplot(data = ToothGrowth) +
  geom_boxplot(mapping = aes(y = len, x = factor(dose)))
