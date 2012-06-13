class Doghouse < ActiveRecord::Base
  belongs_to :user
  
  validates :screen_name, presence: true
  validates :duration_minutes, numericality: {greater_than: 0 }
  validate :tweet_lengths_below_max
  
  attr_accessible :screen_name, :duration_minutes, :enter_tweet, :exit_tweet
  
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
      errors.add(:enter_tweet, 'Too long') if (enter_tweet.length + screen_name.length) > MAX_TWEET_CHARS
      errors.add(:exit_tweet, 'Too long') if (exit_tweet.length + screen_name.length) > MAX_TWEET_CHARS
    end
end
