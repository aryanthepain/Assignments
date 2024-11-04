#importing libraries
install.packages("ggplot2")
library("ggplot2")
install.packages("dplyr")
library("dplyr")
library(readr)

df <- read_csv("drug_deaths.csv")
View(df)
summary(df)
colnames(df)
attach(df)
df=df[,c(-1,-2)]

check=df
df=check

install.packages('tm')
library('tm')

#fixing date
df=filter(df, !is.na(Date))
df$Date=gsub(" 12:00:00 AM", "", df$Date)
df$Date=as.Date(df$Date,"%m/%d/%Y")

View(select(df, c(ResidenceCity:DeathCounty, DeathCityGeo:ResidenceCityGeo)))

#deaths by sex
table=table(df$Sex)
table = table[names(table) != "Unknown"]
barplot(table)

# List of columns related to drugs
all_drugs = c('Heroin', 'Cocaine', 'Fentanyl', 'Fentanyl_Analogue', 'Oxycodone', 
                  'Oxymorphone', 'Ethanol', 'Hydrocodone', 'Benzodiazepine', 'Methadone', 
                  'Amphet', 'Tramad', 'Morphine_NotHeroin', 'Hydromorphone', 'OpiateNOS', 'AnyOpioid')

df$Fentanyl <- as.integer(as.numeric(df$Fentanyl)) 
df$Morphine_Not_Heroin <- as.integer(as.numeric(df$Morphine_Not_Heroin))  
df$Other <- as.integer(as.numeric(df$Other)) 
df$Any_Opioid <- as.integer(as.numeric(df$Any_Opioid)) 
df$Fentanyl_Analogue <- as.integer(as.numeric(df$Fentanyl_Analogue)) 

#most prominent drugs
drug_counts = colSums(df[all_drugs], na.rm = TRUE)
drug_counts_df <- data.frame(Drug = names(drug_counts), Count = as.numeric(drug_counts))

ggplot(data= drug_counts_df) +
  geom_col(mapping=aes(x = reorder(Drug, -Count), y = Count), fill = 'skyblue') +
  labs(title = 'Most Prevalent Drugs Among Overdose Victims',
       x = 'Drug', y = 'Count')+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#deaths by race
table=table(df$Race)
table = table[names(table) != "Unknown"]
table=sort(table, decreasing = TRUE)

par(mar = c(5, 10, 4, 2))
barplot(table, 
        main = "Distribution of Overdose Deaths by Race",
        xlab = "Number of Deaths",
        col = "skyblue",
        horiz = TRUE,
        las = 2)  # las=2 makes the x-axis labels perpendicular for better readability
