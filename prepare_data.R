rm(list = ls())
# Load
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")
library("syuzhet")
library("ggplot2")
library(tidyverse)



text <- readLines("C:/Users/mmoallem/OneDrive - AusNet Services/Desktop/news.txt")
# Load the data as a corpus
text_corpus <- Corpus(VectorSource(text))


#######################################################################3
######## Cleaning Up Text ##############################################
#######################################################################3
#Replacing "/", "@" and "|" with space
toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
text_corpus <- tm_map(text_corpus, toSpace, "/")
text_corpus <- tm_map(text_corpus, toSpace, "@")
text_corpus <- tm_map(text_corpus, toSpace, "\\|")
# Convert the text to lower case
text_corpus <- tm_map(text_corpus, content_transformer(tolower))
# Remove numbers
text_corpus <- tm_map(text_corpus, removeNumbers)
# Remove english common stopwords
text_corpus <- tm_map(text_corpus, removeWords, stopwords("english"))
# Remove your own stop word
# specify your custom stopwords as a character vector
text_corpus <- tm_map(text_corpus, removeWords, c("s", "company", "team")) 
# Remove punctuations
text_corpus <- tm_map(text_corpus, removePunctuation)
# Eliminate extra white spaces
text_corpus <- tm_map(text_corpus, stripWhitespace)
# Text stemming - which reduces words to their root form
text_corpus <- tm_map(text_corpus, stemDocument)

#######################################################################3
######## Building the term document matrix ##############################################
#######################################################################3
# Build a term-document matrix
term_matrix <- as.matrix(TermDocumentMatrix(text_corpus))

# Build a term frequncy dataframe
term_frequency <- data.frame(word = rownames(term_matrix),
                             freq = rowSums(term_matrix)) %>%
  dplyr::arrange(desc(freq))

#######################################################################3
######## Plot the most frequent words ##############################################
#######################################################################3
barplot(term_frequency[1:5,]$freq, las = 2, names.arg = term_frequency[1:5,]$word,
        col ="lightgreen", main ="Top 5 most frequent words",
        ylab = "Word frequencies")

#######################################################################3
######## generate word cloud ##############################################
#######################################################################3
set.seed(1234)
wordcloud(words = term_frequency$word, freq = term_frequency$freq, min.freq = 5,
          max.words=100, random.order=FALSE, rot.per=0.40, 
          colors=brewer.pal(8, "Dark2"))

#######################################################################3
######## generate word cloud ##############################################
#######################################################################3
sentiments <- get_nrc_sentiment(text)

#transpose
sentiments_summary <- data.frame(sentiment = names(sentiments),
                                 count = colSums(sentiments))

#Plot One - count of words associated with each sentiment
quickplot(sentiment, 
          data=sentiments_summary, 
          weight=count, 
          geom="bar", 
          fill=sentiment, 
          ylab="count") + 
  ggtitle("Survey sentiments")



output <- list(term_frequency = term_frequency,
               sentiments_summary = sentiments_summary)

saveRDS(output, 
        "data.RDS")
