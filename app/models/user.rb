class User < ActiveRecord::Base
  MAX_QUERY_LENGTH = 100
  
  has_many :doghouses, dependent: :destroy, order: 'created_at desc'
  
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.nickname = auth["info"]["nickname"]
      user.token = auth['credentials']['token']
      user.secret = auth['credentials']['secret']
    end
  end
  
  def get_following_users
    following_ids = get_following_ids
    users = []
    index = 0
    while index < following_ids.length
      users << Twitter.users(following_ids[index...(index+MAX_QUERY_LENGTH)])
      index += MAX_QUERY_LENGTH
    end
    users.flatten
  end
  
  def twitter_api_authenticate!
    Twitter.configure do |config|
      config.consumer_key = TWITTER_KEY
      config.consumer_secret = TWITTER_SECRET
      config.oauth_token = token
      config.oauth_token_secret = secret
    end
  end
  
  private
  
    def get_following_ids
      following_ids = []
      cursor = -1
      while cursor != 0
        followings = Twitter.friend_ids(nickname, cursor: cursor)
        following_ids << followings.ids
        cursor = followings.next_cursor
      end
      following_ids.flatten
    end
end
