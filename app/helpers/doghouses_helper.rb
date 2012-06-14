module DoghousesHelper
  def following_users_collection
    @following_users.map {|f| ["@#{f.screen_name}", f.screen_name]}
  end
  
  def duration_minutes_multiplier_collection
    [['Minutes', 1], ['Hours', MINUTES_IN_HOUR], ['Days', MINUTES_IN_DAY]]
  end
  
  def canned_tweets_collection(canned_tweets)
    collection = canned_tweets.map {|canned_tweet| [canned_tweet.description, canned_tweet.id]}
    collection.insert 0, ['Custom', 0]
    collection
  end
  
end
