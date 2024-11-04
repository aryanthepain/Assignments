#install.packages("gapminder")
#install.packages("dplyr")
install.packages("ggplot2")
library(gapminder)
library(dplyr)
library(ggplot2)

df=gapminder
attach(df)

grouped_data <- df %>% group_by(country) %>% arrange(year)
growth_data <- grouped_data %>%
  mutate(growth_rate = (lifeExp - lag(lifeExp)) / lag(lifeExp) * 100)
growth_data <- growth_data %>%
  filter(!is.na(growth_rate))
avg_growth_data <- growth_data %>%
  group_by(country) %>%
  summarize(avg_growth_rate = mean(growth_rate, na.rm = TRUE))
highest_growth_country <- avg_growth_data %>%
  arrange(desc(avg_growth_rate)) %>%
  slice(1)

print(highest_growth_country)


top_average_growth_data=avg_growth_data %>%
  arrange(desc(avg_growth_rate)) %>%
  slice(1:5)
top_countries <- top_average_growth_data$country
top_growth_data <- growth_data %>%
  filter(country %in% top_countries)


ggplot(top_growth_data, aes(x = year, y = lifeExp, color = country)) +
  geom_line() +
  labs(title = "Growth of Life Expectancy in Top 5 Countries", 
         x = "Year", 
         y = "Life Expectancy")






df_2007 <- df %>%
  filter(year == 2007) %>%
  mutate(development_status = ifelse(gdpPercap > 12000, "Developed", "Developing"))
disparity_analysis <- df_2007 %>%
  group_by(development_status) %>%
  summarize(avg_lifeExp = mean(lifeExp, na.rm = TRUE))

print(disparity_analysis)





life_exp_improvement <- gapminder %>%
  group_by(continent, year) %>%
  summarize(avg_lifeExp = mean(lifeExp, na.rm = TRUE)) %>%
  arrange(year)
earliest_life_exp <- life_exp_improvement %>%
  filter(year == min(year)) %>%
  select(continent, earliest_lifeExp = avg_lifeExp)
latest_life_exp <- life_exp_improvement %>%
  filter(year == max(year)) %>%
  select(continent, latest_lifeExp = avg_lifeExp)
improvement_data <- earliest_life_exp %>%
  inner_join(latest_life_exp, by = "continent") %>%
  mutate(improvement = latest_lifeExp - earliest_lifeExp)
greatest_improvement <- improvement_data %>%
  arrange(desc(improvement)) %>%
  slice(1)

print(greatest_improvement)


life_exp_by_continent <- df %>%
  group_by(continent, year) %>%
  summarize(avg_lifeExp = mean(lifeExp, na.rm = TRUE))
ggplot(life_exp_by_continent, aes(x = year, y = avg_lifeExp, color = continent)) +
  geom_line() +
  labs(title = "Trends of Life Expectancy Across Continents",
       x = "Year",
       y = "Average Life Expectancy") +
  theme_minimal()
