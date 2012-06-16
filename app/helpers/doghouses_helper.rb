module DoghousesHelper
  
  # Collection of people user follows on twitter for select box
  def following_users_collection
    @following_users.map {|f| ["@#{f.screen_name}", f.screen_name]}
  end
  
  # Collection of possible doghouse duration types for radio buttons
  def duration_minutes_multiplier_collection
    [['Minutes', 1], ['Hours', MINUTES_IN_HOUR], ['Days', MINUTES_IN_DAY]]
  end
  
  # Collection of canned enter and exit tweets for select boxes
  def canned_tweets_collection(canned_tweets)
    collection = canned_tweets.map {|canned_tweet| [canned_tweet.description, canned_tweet.id, {'data-text' => canned_tweet.text}]}
    collection << ['Write My Own', Doghouse::CUSTOM_TWEET]
    collection << ['None', Doghouse::NONE_TWEET]
    collection
  end  
end
