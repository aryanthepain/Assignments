#####################
# Q1#####################
#####################
# install libraries
# install.packages("fpp3")
library(fpp3)

#####################
# Q2#####################
#####################
# 2.a ################
# load the dataset
PBS

# 2.b ################
# filter
PBS |> filter(ATC2 == "A10")

# 2.c ################
# select
PBS |> 
    filter(ATC2 == "A10") |>
    select(Month, Concession, Type, Cost)

# 2.d ################
# summarise
a10 |> 
  summarise(TotalCost = sum(Cost, na.rm = TRUE))
#or
PBS |> 
        filter(ATC2 == "A10") |>
        select(Month, Concession, Type, Cost) |>
        summarise(TotalCost = sum(Cost))

# 2.e ################
# mutate
PBS |> 
        filter(ATC2 == "A10") |>
        select(Month, Concession, Type, Cost) |>
        summarise(TotalC = sum(Cost)) |>
        mutate(Cost = TotalC / 1e6)

# 2.f ################
# save as a10
a10 <- PBS |> 
        filter(ATC2 == "A10") |>
        select(Month, Concession, Type, Cost) |>
        summarise(TotalCost = sum(Cost)) |>
        mutate(Cost = TotalCost / 1e6)

# 2.g ################
# check final output
a10

# 2.h ################
# plot time series
a10 |>
    autoplot(Cost) +
    labs(y = "$ (millions)", title = "Australian anti-diabetic drug sales data")

# 2.i ################
# is there any trend?
# Yes, we can see a very obvious increasing trend in the graph.

# 2.j ################
# is there any seasonal pattern?
# Yes, there is a seasonal pattern in the data, with peaks and troughs occurring at monthly intervals.

# 2.k ################
# seasonal plot
a10 |>
    gg_season(Cost, labels="both") +
    labs(y = "$ (millions)", title = "Seasonal plot of Australian anti-diabetic drug sales")

# 2.l ################
# observartions from seasonal plot
# There is relatively consistent seasonal pattern in the earlier years. However, there is increase in variance and irregularity in the later years.
# Most of the time the cost line does not interact with the last month's cost, with a few exceptions of course.
# The cost first decreases sharply till February, and then slowly increase till next January, where it peaks again.

# 2.m ################
# subseries plot
a10 |>
    gg_subseries(Cost) +
    labs(
        y = "$ (millions)",
        title = "Subseries plot of Australian anti-diabetic drug sales"
        )

#####################
# Q3#####################
#####################

# 3.a ################
# electricity production from aus_production
aus_production |>
    select(Quarter, Electricity) -> electricity
# plot
electricity |>
    autoplot(Electricity) +
    labs(y = "Electricity production", title = "Electricity production in Australia")
# increasing trend, quarterly seasonality, and some irregularity

# seasonal plot
electricity |>
    gg_season(Electricity, labels="both") +
    labs(y = "Electricity production", title = "Seasonal plot of electricity production in Australia")
# high seasonality in earlier years, but less so in the later years.
# increasing variance/irregularity in the later years.
# subseries plot
electricity |>
    gg_subseries(Electricity) +
    labs(
        y = "Electricity production",
        title = "Subseries plot of electricity production in Australia"
    )
# fairly consistent increasing trend.

# 3.b ################
# bricks production from aus_production
aus_production |>
    select(Quarter, Bricks) -> bricks
# plot
bricks |>
    autoplot(Bricks) +
    labs(y = "Bricks production", title = "Bricks production in Australia")
# first increasing trend, and then decreasing trend
# seasonal plot
bricks |>
    gg_season(Bricks, labels="both") +
    labs(y = "Bricks production", title = "Seasonal plot of bricks production in Australia")
# high seasonality in earlier years, but difficult to tell in the later years due to high irregularity.
# subseries plot
bricks |>
    gg_subseries(Bricks) +
    labs(
        y = "Bricks production",
        title = "Subseries plot of bricks production in Australia"
    )
# first increasing trend, and then decreasing or no trend

# 3.c ################
# retail trade from us_employment
us_employment
# sum up the employed
us_employment |>
    summarise(totalEmployed = sum(Employed, na.rm = TRUE)) -> total_employed
# plot
total_employed |>
    autoplot(totalEmployed) +
    labs(y = "Total employed", title = "Total employed in the US")
# seasonal plot
total_employed |>
    gg_season(totalEmployed, labels="both") +
    labs(y = "Total employed", title = "Seasonal plot of total employed in the US")
