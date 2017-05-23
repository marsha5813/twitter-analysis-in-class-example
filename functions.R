




##################################################
##################################################
# clean.tweets.df
##################################################
##################################################

# Cleans tweets that are stored in a data.frame

clean.tweets.df = function(data, column) {
  
  
  # saves raw text for later comparison
  data[["rawtext"]] = data[[column]]
  # remove retweet entities
  data[[column]] = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", data[[column]])
  # remove retweet entities
  data[[column]] = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", data[[column]])
  # remove at people
  data[[column]] = gsub("@\\w+", "", data[[column]])
  # remove punctuation
  data[[column]] = gsub("[[:punct:]]", "", data[[column]])
  # remove numbers
  data[[column]] = gsub("[[:digit:]]", "", data[[column]])
  # remove html links
  data[[column]] = gsub("http\\w+", "", data[[column]])
  # remove unnecessary spaces
  data[[column]] = gsub("[ \t]{2,}", "", data[[column]])
  data[[column]] = gsub("^\\s+|\\s+$", "", data[[column]])
  # remove all non-ASCII characters (removes emojis)
  data[[column]] = iconv(data[[column]], "latin1", "ASCII", sub="")
  
  # define "tolower error handling" function
  try.error = function(x)
  {
    # create missing value
    y = NA
    # tryCatch error
    try_error = tryCatch(tolower(x), error=function(e) e)
    # if not an error
    if (!inherits(try_error, "error"))
      y = tolower(x)
    # result
    return(y)
  }
  # lower case using try.error with sapply
  data[[column]] = sapply(data[[column]], try.error)
  
  # remove NAs in data[[column]]
  # data[[column]] = data[[column]][!is.na(data[[column]])]
  # names(data[[column]]) = NULL
  
  return(data)
  
  
}
    
    
##################################################
##################################################
# clean.tweets
##################################################
##################################################

# Cleans tweets that are stored in a character vector

clean.tweets = function(data) {
  
  
  # remove retweet entities
  data = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", data)
  # remove retweet entities
  data = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", data)
  # remove at people
  data = gsub("@\\w+", "", data)
  # remove punctuation
  data = gsub("[[:punct:]]", "", data)
  # remove numbers
  data = gsub("[[:digit:]]", "", data)
  # remove html links
  data = gsub("http\\w+", "", data)
  # remove unnecessary spaces
  data = gsub("[ \t]{2,}", "", data)
  data = gsub("^\\s+|\\s+$", "", data)
  # remove all non-ASCII characters (removes emojis)
  data = iconv(data, "latin1", "ASCII", sub="")
  
  # define "tolower error handling" function
  try.error = function(x)
  {
    # create missing value
    y = NA
    # tryCatch error
    try_error = tryCatch(tolower(x), error=function(e) e)
    # if not an error
    if (!inherits(try_error, "error"))
      y = tolower(x)
    # result
    return(y)
  }
  # lower case using try.error with sapply
  data = sapply(data, try.error)
  
  # remove NAs in data
  # data = data[!is.na(data)]
  # names(data) = NULL
  
  return(data)
  
  
}



##################################################
##################################################
# map.tweets
##################################################
##################################################

map.tweets = function(data, lat, lon) {
  
  map.data <- map_data("state")
  points <- data.frame(x = as.numeric(data[[lon]]), y = as.numeric(data[[lat]]))
  points <- points[points$y > 25, ]
  ggplot(map.data) + geom_map(aes(map_id = region), map = map.data, fill = "white", 
                              color = "grey20", size = 0.25) + expand_limits(x = map.data$place_lon, y = map.data$place_lat) + 
    theme(axis.line = element_blank(), axis.text = element_blank(), axis.ticks = element_blank(), 
          axis.title = element_blank(), panel.background = element_blank(), panel.border = element_blank(), 
          panel.grid.major = element_blank(), plot.background = element_blank(), 
          plot.margin = unit(0 * c(-1.5, -1.5, -1.5, -1.5), "lines")) + geom_point(data = points, 
                                                                                   aes(x = x, y = y), size = 1, alpha = 1/5, color = "darkblue")
  
  
}





