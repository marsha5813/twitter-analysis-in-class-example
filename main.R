

######################################
#     initialize environment
######################################

install.packages("streamR")
install.packages("ROAuth")
install.packages("sp")
install.packages("maps")
install.packages("maptools")
install.packages("ggplot2")
devtools::install_github("timjurka/sentiment/sentiment")
install.packages("wordcloud")
install.packages("RColorBrewer")

library(streamR)
library(ROAuth)
library(sp)
library(maps)
library(maptools)
library(ggplot2)
library(sentiment)
library(wordcloud)
library(RColorBrewer)


# load my functions
source("functions.R")


# load oauth file
load("my_oauth.Rdata")
 

######################################
#     data collection and cleaning
######################################

# run data collection for all of the United States
filterStream("tweets.json", locations = c(-125, 25, -66, 50), tweets=100000, timeout = 180,
             track = "clinton", oauth = my_oauth, verbose = TRUE)


# parse tweets into a data.frame
tweets.df = parseTweets("tweets.json", verbose=TRUE)

# pre-process the tweets
tweets.df = clean.tweets.df(tweets.df, "text")


######################################
#     sentiment analysis
######################################

# Perform Sentiment Analysis
# classify emotion
class_emo = classify_emotion(tweets.df$text, algorithm='bayes', prior=1.0)
# get emotion best fit
emotion = class_emo[,7]
# substitute NA's by 'unknown'
emotion[is.na(emotion)] = 'unknown'

# classify polarity
class_pol = classify_polarity(tweets.df$text, algorithm='bayes')
# get polarity best fit
polarity = class_pol[,4]
# Create data frame with the results and obtain some general statistics
# data frame with results
sent_df = data.frame(text=tweets.df$text, emotion=emotion,
                     polarity=polarity, stringsAsFactors=FALSE)

# sort data frame
sent_df = within(sent_df,
                 emotion <- factor(emotion, levels=names(sort(table(emotion), decreasing=TRUE))))



######################################
#     data viz
######################################


# map tweets across the U.S.
map.tweets(tweets.df, "place_lat", "place_lon") ## maps tweets across the U.S. (still throws some errors)

# plot polarity
ggplot(sent_df, aes(x=polarity)) +
  geom_bar(aes(y=..count.., fill=polarity)) +
  scale_fill_brewer(palette='RdGy') +
  labs(x='polarity categories', y='number of tweets') +
  ggtitle('Sentiment Analysis of Tweets\n(classification by polarity)') +
  theme(plot.title = element_text(size=12, face='bold'))

# plot emotions
ggplot(sent_df, aes(x=emotion)) +
  geom_bar(aes(y=..count.., fill=emotion)) +
  scale_fill_brewer(palette='Dark2') +
  labs(x='emotion categories', y='number of tweets') +
  ggtitle('Sentiment Analysis of Tweets about Starbucks\n(classification by emotion)') +
  theme(plot.title = element_text(size=12, face='bold'))

# Separate the text by emotions and visualize the words with a comparison cloud
# separating text by emotion
emos = levels(factor(sent_df$emotion))
nemo = length(emos)
emo.docs = rep('', nemo)
for (i in 1:nemo)
{
  tmp = tweets.df$text[emotion == emos[i]]
  emo.docs[i] = paste(tmp, collapse=' ')
}

# remove stopwords
emo.docs = removeWords(emo.docs, stopwords('english'))
# create corpus
corpus = Corpus(VectorSource(emo.docs))
tdm = TermDocumentMatrix(corpus)
tdm = as.matrix(tdm)
colnames(tdm) = emos

# comparison word cloud
comparison.cloud(tdm, colors = brewer.pal(nemo, 'Dark2'),
                 scale = c(3,.5), random.order = FALSE, title.size = 1.5)



