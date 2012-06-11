class Doghouse < ActiveRecord::Base
  belongs_to :user
  scope :release_candidates, lambda {
    where("(is_released = ? OR is_released IS NULL) AND release_date_time < ?", false, Time.now)
  }
  
  validates :screen_name, presence: true
  validates :duration_minutes, numericality: {greater_than: 0 }
  
  attr_accessor :duration_minutes
  attr_accessible :screen_name, :duration_minutes
  
  before_save :set_release_date_time
  after_create :unfollow!
  
  def self.release_applicable_candidates
    Doghouse.release_candidates.all.each {|to_release| to_release.release!}
  end
  
  def release!
    user.twitter_api_authenticate!
    Twitter.follow(screen_name)
    update_attribute(:is_released, true)
  end
  
  private
    
    def unfollow!
      user.twitter_api_authenticate!
      Twitter.unfollow(screen_name)
    end
    
    def set_release_date_time
      self.release_date_time = (created_at ? created_at : Time.now) + duration_minutes.to_i.minutes
    end
end
