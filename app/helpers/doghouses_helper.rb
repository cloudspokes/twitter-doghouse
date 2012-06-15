module DoghousesHelper
  def following_users_collection
    @following_users.map {|f| ["@#{f.screen_name}", f.screen_name]}
  end
  
  def duration_minutes_multiplier_collection
    [['Minutes', 1], ['Hours', MINUTES_IN_HOUR], ['Days', MINUTES_IN_DAY]]
  end
  
  def canned_tweets_collection(canned_tweets)
    collection = canned_tweets.map {|canned_tweet| [canned_tweet.description, canned_tweet.id, {:'data-text' => canned_tweet.text}]}
    collection << ['Write My Own', Doghouse::CUSTOM_TWEET]
    collection << ['None', Doghouse::NONE_TWEET]
    collection
  end
  
  def doghouse_table_data
    to_return = {headings: ['Twitter username', 'Created on', 'Expires in', 'Expiration tweet', ''], data: []}
    for doghouse in @doghouses
      to_return[:data] << [
        
      ]
    end
    to_return
  end
  
end
