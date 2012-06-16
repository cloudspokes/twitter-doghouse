# This table represents users of the Twitter Doghouse app
class User < ActiveRecord::Base
  MAX_QUERY_LENGTH = 100 # Enforced by twitter API
  
  has_many :doghouses, dependent: :destroy, order: 'created_at desc'
  has_many :active_doghouses, class_name: 'Doghouse', conditions: ["is_released IS NULL"], order: 'created_at desc'
  has_many :request_from_twitters, dependent: :destroy
  
  # Create a new user from Twitter's omniauth response
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.nickname = auth["info"]["nickname"]
      user.image = auth["info"]["image"]
      user.token = auth['credentials']['token']
      user.secret = auth['credentials']['secret']
    end
  end
  
  # Get a list of Twitter Users that the user follows on twitter
  def get_following_users
    # Cache the results for 3 minutes
    Rails.cache.fetch("following_users_#{id}", expires_in: 3.minutes) do
      following_ids = get_following_ids
      users = []
      index = 0
      # Can only query for the details (screen name, profile image, etc.) of 100 users at a time
      while index < following_ids.length
        users << Twitter.users(following_ids[index...(index+MAX_QUERY_LENGTH)])
        index += MAX_QUERY_LENGTH
      end
      users.flatten
    end
  end
  
  # Authenticate the user with the twitter API
  # Must be called before performing actions such as following, unfollow and tweeting
  def twitter_api_authenticate!
    Twitter.configure do |config|
      config.consumer_key = TWITTER_KEY
      config.consumer_secret = TWITTER_SECRET
      config.oauth_token = token
      config.oauth_token_secret = secret
    end
  end
  
  private
  
    # Get all of the ids of the Twitter Users that the user follows
    def get_following_ids
      following_ids = []
      cursor = -1
      # Grabs 5000 at a time until the cursor is set to 0
      while cursor != 0
        followings = Twitter.friend_ids(nickname, cursor: cursor)
        following_ids << followings.ids
        cursor = followings.next_cursor
      end
      following_ids.flatten
    end
end
