class Doghouse < ActiveRecord::Base
  belongs_to :user
  
  validates :screen_name, presence: true
  validates :duration_minutes, numericality: {greater_than: 0 }
  
  attr_accessible :screen_name, :duration_minutes
  
  after_create :unfollow!
  after_create :create_release_job
  after_save :update_job, on: :update, unless: :is_released
  after_destroy :remove_job, unless: :is_released
  
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
      update_attribute(:job_id, Doghouse.delay(run_at: duration_minutes.minutes.from_now).release!(id).id)
    end
    
    def self.release!(doghouse_id)
      dogouse = Doghouse.find(doghouse_id)
      dogouse.user.twitter_api_authenticate!
      Twitter.follow(dogouse.screen_name)
      dogouse.update_attribute(:is_released, true)
      Rails.cache.delete "following_users_#{doghouse.user.id}"
    end
    
    def update_job
      Delayed::Backend::ActiveRecord::Job.find(job_id).update_attribute(:run_at,  created_at + duration_minutes.minutes)
    end
    
    def remove_job
      Delayed::Backend::ActiveRecord::Job.find(job_id).destroy
    end
end
