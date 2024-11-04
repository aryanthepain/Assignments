# concatenate into a vector
x <- c(1, 2, 3, 4)
# length of a vector
length(x)
# adding two vectors
y <- c(4, 5, 6, 8)
x + y
# smaller vector must be a multiple of shorter vector
# list variables
ls()
# remove variables
rm(n)
# to remove all var, rm(list=ls())
# matrix
m <- matrix(data = x, nrow = 2, ncol = 2)
n <- matrix(x, 2, 2)
# put byrow=TRUE to populate matrix horizontally
# square and square root
sqrt(x)
x^2
# random normal var rnorm(number of values, mean, standard deviation)
# by default mean=0, sd=1
r <- rnorm(50)
# correlation between two vectors cor()
y <- r + rnorm(50, mean = 50, sd = 0.1)
cor(y, r)
# set seed for rnorm
set.seed(3692)
# for mean, mean()
mean(r)
# for variance, var()
var(y)
# for standard deviation
sqrt(var(y))
# or
sd(y)
# plot
plot(r, y, xlab = "x-axis", ylab = "y-axis", main = "x vs y")

# pdf
pdf("figure.pdf") # starts making a file
plot(r, y, col = "green")
dev.off() # we are done creating the plot
# sequence
seq(1, 10)
1:10
x <- seq(-pi, pi, length = 50)
# contour plot
y <- x
f <- outer(x, y, function(x, y) cos(y) / (1 + x^2))
# outer function takes two vectors and a function as argument
# each corresponding elements of two vectors go through the function and outputted
contour(x, y, f, nlevels = 45, add = T)
# add=T is to put two plots oin one fig
fa <- (f - t(f)) / 2
# t() is transpose
# heatmap
image(x, y, fa)
# 3d plot, theta and phi for angles
persp(x, y, fa, theta = 30, phi = 40)
# indexing
a <- matrix(1:16, 4, 4)
a[2, 3] # will be 10
# for multiple
a[c(1, 3), c(2, 4)]
a[1:3, 2:4]
a[1:2, ]
# negative sign to exclude values
a[-c(1, 3), ]
dim(a) # dimension of matrix
# tables
# import a data set
df <- read.table("Auto.data")
View(df) # to view as spreadsheet
head(df) # to view first few elements
# csv file
auto <- read.csv("Auto.csv", na.strings = "?", header = T, stringsAsFactors = T)
auto <- mtcars
attach(auto)
View(auto)
head(auto)
# header tells first line is header in csv
# strings as factors tells that each word is a qualititive value
# na.strings tells empty values
auto <- na.omit(auto) # omits empty lines
names(auto) # tells names of the headers
plot(auto$cylinders, auto$mpg) # cylinders and mpg can't be used directly as variables
attach(auto) # to use as var
plot(cylinders, mpg)
# The as.factor() function converts quantitative variables into qualitative variables.
cylinders <- as.factor(cylinders)
plot(cylinders, mpg, col = "red", varwidth = T, xlab = "cylinders", ylab = "MPG")
# boxplot if one is quant and one is qual
# histogram
hist(mpg, col = 2, breaks = 15)
# pairplot
pairs(auto)
pairs(
  ~ mpg + displacement + horsepower + weight + acceleration,
  data = auto
) # to get specific variables
plot(horsepower, mpg)
identify(horsepower, mpg, name)
