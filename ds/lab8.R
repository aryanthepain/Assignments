# import data set
data <- read.csv("./spam_ham_subset.csv")

# Load wordcloud library
library(wordcloud) #  For making wordcloud
library(tm) # For Text Mining
library(slam)
library(SnowballC) # For Text Processing
library(e1071) # For Naive Bayes
library(caret) # For the Confusion Matrix

# spam wordcloud
wordcloud(data$Message[data$Category == "spam"],
  max.words = 100, random.order = FALSE,
  colors = brewer.pal(7, "Dark2")
)
# ham wordcloud
wordcloud(data$Message[data$Category == "ham"],
  max.words = 100, random.order = FALSE,
  colors = brewer.pal(7, "Dark2")
)

# proportion of data
table(data$Category)

# text preprocessing
sms_corpus <- tm::VCorpus(tm::VectorSource(data$Message))
as.character(sms_corpus[[1]])
sms_corpus[[1]]
corpus_clean <- tm::tm_map(sms_corpus, tm::content_transformer(tolower))
corpus_clean <- tm::tm_map(corpus_clean, tm::removePunctuation)
corpus_clean <- tm::tm_map(corpus_clean, tm::removeNumbers)
corpus_clean <- tm::tm_map(corpus_clean, tm::stemDocument)
corpus_clean <- tm::tm_map(corpus_clean, tm::removeWords, tm::stopwords("en"))
as.character(corpus_clean[[1]])
corpus_clean[[1]]

# tokenisation
sms_dtm <- DocumentTermMatrix(corpus_clean)

# test train split
df_dtm_train <- sms_dtm[1:700, ]
df_cat_train <- data$Category[1:700]
df_dtm_test <- sms_dtm[701:1000, ]
df_cat_test <- data$Category[701:1000]

# the train data is representative of the whole data
prop.table(table(df_cat_train))
prop.table(table(data$Category))

# remove words that appear in less messages as they are not necessary and increase complexity
threshold <- 0.3 # remove words that appear in less than 0.3% messages
min_freq <- round(sms_dtm$nrow * (threshold / 100), 0)
min_freq
# Create vector of most frequent words
# first find number of words without the threshold
freq_words <- findFreqTerms(x = sms_dtm, lowfreq = 0)
str(freq_words)
freq_words <- findFreqTerms(x = sms_dtm, lowfreq = min_freq)
str(freq_words)

# colnames_lower <- tolower(colnames(df_dtm_train))
# freq_words_lower <- tolower(freq_words)

# Check if freq_words are in the column names
# all(freq_words_lower %in% colnames_lower)
# missing_terms <- freq_words[!freq_words_lower %in% colnames_lower]
# print(missing_terms)
# Filter the DTM
df_dtm_freq_train <- df_dtm_train[, freq_words]
df_dtm_freq_test <- df_dtm_test[, freq_words]

dim(df_dtm_freq_train)
dim(df_dtm_freq_test)

# converts numerical 0/1 into categorical yes/no
convert_values <- function(x) {
  x <- ifelse(x > 0, "Yes", "No")
}

sms_train <- apply(df_dtm_freq_train,
  MARGIN = 2,
  convert_values
)
sms_test <- apply(df_dtm_freq_test,
  MARGIN = 2,
  convert_values
)
# MARGIN=2 for columns, 1 for rows

# making the naive bayes model
sms_classifier <- naiveBayes(sms_train, df_cat_train)

# Make predictions
sms_test_pred <- predict(sms_classifier, sms_test)
df_cat_test_level <- factor(df_cat_test, levels = c("ham", "spam"))

# Create confusion matrix
confusionMatrix(
  data = sms_test_pred, reference = df_cat_test_level,
  positive = "spam"
)
