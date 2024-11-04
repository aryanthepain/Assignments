# install.packages("dplyr")
library("dplyr")

df <- data.frame(Theoph) # dataframe in R
head(df)
names(df)
attach(df)
select(df, Subject:Dose) # select some rows or columns
filter(df, Dose > 5)
filter(df, Dose > 5, Time > mean(Time)) # filter rows or columns
arrange(df, desc(Wt)) # arrange in ascending or descending
mutate(df, trend = Time - mean(Time)) # creates new var
# use transmute to create in place
# collapses df to single row and makes it easier to preprocess
dplyr::summarise(df, Wt = mean(Wt), Time = mean(Time))
which(is.na(df)) # find null entries

# preprocessing
install.packages("tm")
library("tm")
install.packages("SnowballC")
library(SnowballC)
m <- data.frame(c("l am WANTING to go to school but 34 #", "I love chocolates 345 @", "we should stop getting worried so easily "))
names(m) <- "text"
post <- Corpus(VectorSource(m$text))
post
# removing numbers
post <- tm_map(post, removeNumbers)
writeLines(as.character(post[1]))
# removing punctuations
post <- tm_map(post, removePunctuation)
writeLines(as.character(post[1]))
# removing whitespace
post <- tm_map(post, stripWhitespace)
writeLines(as.character(post[1]))
# convert case
post <- tm_map(post, content_transformer(tolower))
writeLines(as.character(post[1]))
# removing stopwords(not much contribution to meaning) a,the, if,etc.
post <- tm_map(post, removeWords, stopwords("english"))
writeLines(as.character(post[1]))
writeLines(as.character(post[2]))
writeLines(as.character(post[3]))
# stemming, or converting similar words like offering, offered, offer to one word
post <- tm_map(post, stemDocument)
writeLines(as.character(post[1]))

m <- data.frame(c("l am WANTING to go to school but 34 #", "I love chocolates 345 @", "we should stop getting worried so easily "))
names(m) <- "text"
post <- Corpus(VectorSource(m$text))
post <- post %>%
    tm_map(removeNumbers) %>%
    tm_map(removePunctuation) %>%
    tm_map(stripWhitespace) %>%
    tm_map(content_transformer(tolower)) %>%
    tm_map(removeWords, stopwords("english")) %>%
    tm_map(stemDocument)
writeLines(as.character(post[1]))

new_m <- data.frame(text = sapply(post, as.character), stringsAsFactors = FALSE)
attach(new_m)
nchar(text) # counts the number of characters including whitespace
gsub(" ", "", text) # replaces text
