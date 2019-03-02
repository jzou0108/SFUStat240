#Twitter Authentication with R
#twitteR package and wordcloud package
#Obtain an API key first
# Declare Twitter API Credentials
consumer_key = "YOUR API KEY"
consumer_secret = "YOUR API SECRET"
access_token = "YOUR ACCESS TOKEN"
access_secret = "ACCESS TOKEN SECRET"
# create twitter connection
setup_twitter_oauth(consumer_key, consumer_secret,
                    access_token, access_secret)

#searchTwitter() about a topic
dsTweets = searchTwitter(searchString = "#datascience",
                         n = 2000, lang = "en")
#to data frame
dsTweetsDF = twListToDF(dsTweets)

hist(dsTweetsDF[, "retweetCount"], 100,
     freq = F, main = "Q2c:Re-Tweet Counts for #datascience",
     xlab = "Retweets", ylim = c(0, 0.08))
lines(density(dsTweetsDF[, "retweetCount"], 
              from = 0), col = 2, lwd = 2)

#text: the text of the actual tweet
#created: the date and timestamp of the creation of the tweet
#screenName: the user name that creates the tweet
#isRetweet: a boolean value indicating if a tweet is a retweet or not
#retweetCount: number of times the tweet has been retweeted

MoreTweets2 = subset(MoreTweetsDF, isRetweet ==
                       FALSE, select = c(text, created, favoriteCount,
                                         created, screenName, isRetweet, retweetCount))

#Checking your API usage
usage = getCurRateLimitInfo()
usage[usage[, "remaining"] != usage[,"limit"], ]

#tweets from a speciﬁc user
obtainedTweets = userTimeline("SFU",n = 1000)

#Word Cloud
x = "Split the words in a sentence."strsplit(x, " ")

## [[1]]
## [1] "Split" "the" "words"
## [4] "in" "a" "sentence."

x = "Split at every character."
strsplit(x, "")
## [[1]]
## [1] "S" "p" "l" "i" "t" " " "a" "t" " " "e" "v"
## [12] "e" "r" "y" " " "c" "h" "a" "r" "a" "c" "t"
## [23] "e" "r" "."

library(wordcloud)
# create a vector of words
words = c("a", rep("b", 2), rep("c", 3),
          rep("d", 4), rep("e", 5))
# count the frequency of each word in
# the vector
freq = table(words)
# produce a word cloud
wordcloud(names(freq), freq, min.freq = 1,
          colors = rainbow(8), random.order = FALSE)

# sort by retweetCount in descending
# order
MoreTweets2_sorted = MoreTweets2[order(-MoreTweets2$retweetCount),]
# print out top 10 tweets
head(MoreTweets2_sorted$text, 10)

# Generate a wordcloud
tweets_subset = subset(MoreTweets2_sorted,
                       retweetCount > 7)
word.list = strsplit(tweets_subset$text,
                     " ")
words = unlist(word.list)
freq = table(words)
wordcloud(names(freq), freq, min.freq = 2,colors = rainbow(8), random.order = FALSE)