module DoghousesHelper
  def following_users_collection
    @following_users.map {|f| ["@#{f.screen_name}", f.screen_name]}
  end
  
  def duration_minutes_multiplier_collection
    [['Minutes', 1], ['Hours', MINUTES_IN_HOUR], ['Days', MINUTES_IN_DAY]]
  end
end
