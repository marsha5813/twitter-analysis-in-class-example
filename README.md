# README
This is a fun little data collection and visualization program that I use for an in-class teaching example about collecting and analyzing Twitter data in R.

## Acknowledgements
A lot of the code in this example was modified from Colin Priest's tutorial, "Using R and Twitter to Analyse Consumer Sentiment." https://colinpriest.com/2015/07/04/tutorial-using-r-and-twitter-to-analyse-consumer-sentiment/


## Instructions
To use this code, you first need to download R and RStudio: https://courses.edx.org/courses/UTAustinX/UT.7.01x/3T2014/56c5437b88fa43cf828bff5371c6a924/

Next, you need to create and register an app at dev.twitter.com. You can find more detailed instructions in this tutorial: https://colinpriest.com/2015/07/04/tutorial-using-r-and-twitter-to-analyse-consumer-sentiment/

However, unlike in the hyperlinked example above, this program streams tweets via the streaming API and the streamR package. One major difference between twitteR (used in Colin Priest's tutorial) and streamR is that the authorization set-up is a bit different.

The filterStream command (from the streamR package) takes an "oauth" argument in which you can pass an oauth object that contains your authorization credentials. The Github repo does not include my oauth file for privacy reasons -- you need to set this up yourself. To do this, you must first create and register your app at dev.twitter.com. Then use the credentials supplied by Twitter to get a consumer key and consumer secret. Run the following R code to create and save your own oauth object as class (oauth). Replace xxxxxxxxxxxx with your own consumer key and consumer secret.

```
library(ROAuth)
requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <- "xxxxxxxxxxxxxxxxxx"
consumerSecret <- "xxxxxxxxxxxxx"
my_oauth <- OAuthFactory$new(consumerKey=consumerKey,
                            consumerSecret=consumerSecret, requestURL=requestURL,
                            accessURL=accessURL, authURL=authURL)
my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))
save(my_oauth, file = "my_oauth.Rdata")
```

Once you've set up your authorization credentials, everything else should run smoothly. You can play around with parameters, such as where you'd like to collect tweets (currently I have input a bounding box around the continental United States) and what topics you'd like to search for.

## Examples:

Stream tweets related to "kitten"

```
filterStream("tweets.json", tweets=100000, timeout = 180,
             track = "kitten", oauth = my_oauth, verbose = TRUE)
```

Stream tweets related to "kitten" or within the continental United States

```
filterStream("tweets.json", locations = c(-125, 25, -66, 50), tweets=100000, timeout = 180,
             track = "clinton", oauth = my_oauth, verbose = TRUE)
```


Stream tweets (geocoded tweets only) within the continental United States

```
filterStream("tweets.json", locations = c(-125, 25, -66, 50), tweets=100000, timeout = 180,
             oauth = my_oauth, verbose = TRUE)
```

Stream tweets within the continental United States, but leave the stream open for thirty minutes or until 1,000,000 tweets have been collected

```
filterStream("tweets.json", locations = c(-125, 25, -66, 50), tweets=1000000, timeout = 1800,
             oauth = my_oauth, verbose = TRUE)
```



