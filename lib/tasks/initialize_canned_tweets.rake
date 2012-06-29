task :initialize_canned_tweets => :environment do
  # Clear canned tweets
  CannedTweet.all.each {|canned_tweet| canned_tweet.destroy}
  
  #Enter tweets
  CannedTweet.create description: 'Too many tweets', text: "Too many tweets! I\'ve put you in my Twitter DogHouse for a little while.", tweet_type: CannedTweet::ENTER_TYPE
  CannedTweet.create description: 'Quit your yapping', text: "You're going in my DogHouse until you quit your yapping.", tweet_type: CannedTweet::ENTER_TYPE
  CannedTweet.create description: 'Barking up wrong tree', text: "If you're expecting me to read so many tweets, then you're barking up the wrong tree. DogHouse for you.", tweet_type: CannedTweet::ENTER_TYPE
  CannedTweet.create description: 'Less is more', text: "Less is definitely more. For instance, when you tweet less, I like you more. DogHouse.", tweet_type: CannedTweet::ENTER_TYPE
  CannedTweet.create description: 'I like you...', text: "I like you... and I want it to stay that way. I'm putting you in my DogHouse for over-tweeting.", tweet_type: CannedTweet::ENTER_TYPE
  
  #Exit tweets
  CannedTweet.create description: 'Welcome back', text: "Welcome back to my Twitter feed. I hope your time in my DogHouse has set you straight.", tweet_type: CannedTweet::EXIT_TYPE
  CannedTweet.create description: 'Following you is a tweet', text: "I'm letting you out of my DogHouse because following you is a real tweet!", tweet_type: CannedTweet::EXIT_TYPE
  CannedTweet.create description: 'Puppy eyes', text: "Aww I can't take those puppy-eyes. You're out of my DogHouse.", tweet_type: CannedTweet::EXIT_TYPE
  CannedTweet.create description: 'Doggonit', text: "You're out of the DogHouse because, well, doggonit, I can't stay mad at you!", tweet_type: CannedTweet::EXIT_TYPE
  CannedTweet.create description: 'Into my pocket', text: "You're now out of my DogHouse. Welcome back to my pocket!", tweet_type: CannedTweet::EXIT_TYPE
end