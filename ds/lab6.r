#importing libraries
install.packages("ggplot2")
library("ggplot2")
install.packages("dplyr")
library("dplyr")
install.packages("readr")
library("readr")
install.packages("ggthemes")
library(ggthemes)


#preparing data frame
df = read_csv("train.csv")
df1= read_csv("test.csv")
df= bind_rows(df,df1)
View(df)
colnames(df)
attach(df)

df=df[, c(-1)]

#checkpoint
check=df
df=check

# Grab title from passenger names
df$Title = gsub('(.*, )|(\\..*)', '', df$Name)
#.*-any sequence of characters, like % in SQL
# '|' or function
# '\\.' - for full stop

table(df$Sex, df$Title)

rare_title <- c('Dona', 'Lady', 'the Countess','Capt', 'Col', 'Don', 
                'Dr', 'Major', 'Rev', 'Sir', 'Jonkheer')
df$Title[df$Title == 'Mlle']        <- 'Miss' 
df$Title[df$Title == 'Ms']          <- 'Miss'
df$Title[df$Title == 'Mme']         <- 'Mrs' 
df$Title[df$Title %in% rare_title]  <- 'Rare'
rm(rare_title)

table(df$Sex, df$Title)

df$Surname <- sapply(df$Name,  
                       function(x) strsplit(x, split = '[,.]')[[1]][1])

# Create a family size variable including the passenger themselves
df$Fsize <- df$SibSp + df$Parch + 1

ggplot(df[!is.na(df$Survived),], aes(x = Fsize, fill = factor(Survived))) +
  geom_bar(stat='count', position='dodge') +
  scale_x_continuous(breaks=c(1:11)) +
  labs(x = 'Family Size') +
  theme_few()

# Discretize family size
df$FsizeD[df$Fsize == 1] <- 'singleton'
df$FsizeD[df$Fsize < 5 & df$Fsize > 1] <- 'small'
df$FsizeD[df$Fsize > 4] <- 'large'

library(ggplot2)

ggplot(data = df[!is.na(df$Survived),]) +
  geom_bar(mapping = aes(x = FsizeD, fill = factor(Survived)), stat = "count", position = "dodge") +
  labs(x = 'Family Size', y = 'Count', fill = 'Survived') +
  theme_few()

df$Deck<-factor(sapply(df$Cabin, function(x) strsplit(x, NULL)[[1]][1]))

#NULL values imputation
#embarked
View(df[is.na(df$Embarked),])

embark_fare = df %>%
  filter(!is.na(Embarked))
ggplot(embark_fare, aes(x = Embarked, y = Fare, fill = factor(Pclass))) +
  geom_boxplot() +
  geom_hline(aes(yintercept=80), 
             colour='red', linetype='dashed', lwd=2) +
  theme_few()

# C is closest to 80
df$Embarked[c(62, 830)] <- 'C'
rm(embark_fare)

#Fare
View(df[is.na(df$Fare),])

#lets check if fare depends on age
ggplot(df[df$Embarked == 'S' & df$Pclass == 3 & df$Fare !=0 ,], aes(x = Age, y=Fare)) +
  geom_line() +
  theme_few()
#no such dependence

ggplot(df[df$Pclass == '3' & df$Embarked == 'S', ], 
  aes(x = Fare)) +
  geom_density(fill = '#99d6ff', alpha=0.4) + 
  geom_vline(aes(xintercept=median(Fare, na.rm=T)),
             colour='red', linetype='dashed', lwd=1) +
  theme_few()
#median is the most appropriate imputation
median_fare <- median(df[df$Pclass == '3' & df$Embarked == 'S', ]$Fare, na.rm = TRUE)
df$Fare[is.na(df$Fare)][1] <- median_fare
rm(median_fare)

#age
sum(is.na(df$Age))
install.packages('mice')
library('mice')
install.packages('randomForest')
library('randomForest')

# Make variables factors into factors
factor_vars <- c('Pclass','Sex','Embarked',
                 'Title','Surname','FsizeD')

df[factor_vars] <- lapply(df[factor_vars], function(x) as.factor(x))

# Set a random seed
set.seed(129)

# Perform mice imputation, excluding certain less-than-useful variables:
mice_mod <- mice(df[, !names(df) %in% c('Name','Ticket','Cabin','Surname','Survived')], method='rf') 
mice_output <- complete(mice_mod)
par(mfrow=c(1,2))
hist(df$Age, freq=F, main='Age: Original Data', 
     col='darkgreen', ylim=c(0,0.04))
hist(mice_output$Age, freq=F, main='Age: MICE Output', 
     col='lightgreen', ylim=c(0,0.04))

df$Age <- mice_output$Age

# Show new number of missing Age values
sum(is.na(df$Age))

ggplot(df[1:891,], aes(Age, fill = factor(Survived))) + 
  geom_histogram() + 
  facet_grid(.~Sex) + 
  theme_few()

df$Child[df$Age < 18] <- 'Child'
df$Child[df$Age >= 18] <- 'Adult'

# Show counts
table(df$Child, df$Survived)

df$Mother <- 'Not Mother'
df$Mother[df$Sex == 'female' & df$Parch > 0 & df$Age > 18 & df$Title != 'Miss'] = 'Mother'

# Show counts
table(df$Mother, df$Survived)

df$Child  <- factor(df$Child)
df$Mother <- factor(df$Mother)

md.pattern(df)

#predictions
train <- df[1:891,]
test <- df[892:1309,]

rf_model <- randomForest(factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + 
                           Fare + Embarked + Title + 
                           FsizeD + Child + Mother,
                         data = train)

plot(rf_model, ylim=c(0,0.36))
legend('topright', colnames(rf_model$err.rate), col=1:3, fill=1:3)

importance    <- importance(rf_model)
varImportance <- data.frame(Variables = row.names(importance), 
                            Importance = round(importance[ ,'MeanDecreaseGini'],2))

# Create a rank variable based on importance
rankImportance <- varImportance %>%
  mutate(Rank = paste0('#',dense_rank(desc(Importance))))

# Use ggplot2 to visualize the relative importance of variables
ggplot(rankImportance, aes(x = reorder(Variables, Importance), 
                           y = Importance, fill = Importance)) +
  geom_bar(stat='identity') + 
  geom_text(aes(x = Variables, y = 0.5, label = Rank),
            hjust=0, vjust=0.55, size = 4, colour = 'red') +
  labs(x = 'Variables') +
  coord_flip() + 
  theme_few()

# Predict using the test set
prediction <- predict(rf_model, test)

# Save the solution to a dataframe with two columns: PassengerId and Survived (prediction)
solution <- data.frame(Survived = prediction)

# Write the solution to file
write.csv(solution, file = 'rf_mod_Solution.csv', row.names = F)
