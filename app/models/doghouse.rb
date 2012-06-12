class Doghouse < ActiveRecord::Base
  belongs_to :user
  
  validates :screen_name, presence: true
  validates :duration_minutes, numericality: {greater_than: 0 }
  
  attr_accessible :screen_name, :duration_minutes
  
  after_create :unfollow!
  after_create :create_release_job
  
  def release_date_time
    created_at + duration_minutes.minutes
  end
  
  private
    
    def unfollow!
      user.twitter_api_authenticate!
      Twitter.unfollow(screen_name)
      cache_key = "following_users_#{user.id}"
      Rails.cache.write(cache_key, Rails.cache.read(cache_key).reject{|f| f.screen_name == screen_name}) if Rails.cache.read(cache_key)
    end
    
    def create_release_job
      Doghouse.delay(run_at: duration_minutes.minutes.from_now).release!(id)
    end
    
    def self.release!(doghouse_id)
      dogouse = Doghouse.find(doghouse_id)
      dogouse.user.twitter_api_authenticate!
      Twitter.follow(dogouse.screen_name)
      dogouse.update_attribute(:is_released, true)
    end
end
