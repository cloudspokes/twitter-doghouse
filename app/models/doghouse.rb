class Doghouse < ActiveRecord::Base
  belongs_to :user
  belongs_to :request_from_twitter
  
  validates :screen_name, presence: true
  validates :duration_minutes, numericality: {greater_than: 0 }
  validates :duration_minutes_multiplier, numericality: {greater_than: 0 }, allow_blank: true
  validate :tweet_lengths_below_max
  
  attr_accessor :duration_minutes_multiplier, :canned_enter_tweet_id, :canned_exit_tweet_id
  attr_accessible :screen_name, :duration_minutes, :enter_tweet, :exit_tweet, :duration_minutes_multiplier, :canned_enter_tweet_id, :canned_exit_tweet_id
  attr_accessible :screen_name, :duration_minutes, :request_from_twitter_id, :enter_tweet, as: :safe_code
  
  before_create :multiply_duration_minutes, if: :duration_minutes_multiplier
  before_save :handle_canned_tweets
  after_create :enter_doghouse_actions
  after_save :update_job, on: :update, unless: :is_released
  after_destroy :remove_job, unless: :is_released
  
  def release_date_time
    created_at + duration_minutes.minutes
  end
  
  private
  
    def enter_doghouse_actions
      user.twitter_api_authenticate!
      unfollow!
      create_release_job!
      Doghouse.delay.send_enter_tweet!(id)
    end
    
    def unfollow!
      Twitter.unfollow(screen_name)
      cache_key = "following_users_#{user.id}"
      Rails.cache.write(cache_key, Rails.cache.read(cache_key).reject{|f| f.screen_name == screen_name}) if Rails.cache.read(cache_key)
    end
    
    def create_release_job!
      update_attribute(:job_id, Doghouse.delay(run_at: duration_minutes.minutes.from_now).release!(id).id)
    end
    
    def self.send_enter_tweet!(doghouse_id)
      doghouse = Doghouse.get_doghouse_and_authenticate doghouse_id
      Twitter.update("@#{doghouse.screen_name} #{doghouse.enter_tweet}") if doghouse.enter_tweet.present?
    end
    
    def self.send_exit_tweet!(doghouse_id)
      doghouse = Doghouse.get_doghouse_and_authenticate doghouse_id
      Twitter.update("@#{doghouse.screen_name} #{doghouse.exit_tweet}") if doghouse.exit_tweet.present?
    end
    
    def self.release!(doghouse_id)
      doghouse = Doghouse.get_doghouse_and_authenticate doghouse_id
      Twitter.follow(doghouse.screen_name)
      Doghouse.delay.send_exit_tweet!(doghouse.id)
      doghouse.update_attribute(:is_released, true)
      Rails.cache.delete "following_users_#{doghouse.user.id}"
    end
    
    def update_job
      Delayed::Backend::ActiveRecord::Job.find(job_id).update_attribute(:run_at,  created_at + duration_minutes.minutes)
    end
    
    def remove_job
      Delayed::Backend::ActiveRecord::Job.find(job_id).destroy
    end
    
    def self.get_doghouse_and_authenticate(doghouse_id)
      doghouse = Doghouse.find(doghouse_id)
      doghouse.user.twitter_api_authenticate!
      doghouse
    end
    
    def tweet_lengths_below_max
      errors.add(:enter_tweet, 'Too long') if enter_tweet and (enter_tweet.length + screen_name.length) > MAX_TWEET_CHARS
      errors.add(:exit_tweet, 'Too long') if exit_tweet and (exit_tweet.length + screen_name.length) > MAX_TWEET_CHARS
    end
    
    def multiply_duration_minutes
      self.duration_minutes = duration_minutes.to_i * duration_minutes_multiplier.to_i
    end
    
    def handle_canned_tweets
      self.enter_tweet = CannedTweet.find(canned_enter_tweet_id).text if canned_enter_tweet_id and canned_enter_tweet_id.to_i.nonzero?
      self.exit_tweet = CannedTweet.find(canned_exit_tweet_id).text if canned_exit_tweet_id and canned_exit_tweet_id.to_i.nonzero?
    end
end
