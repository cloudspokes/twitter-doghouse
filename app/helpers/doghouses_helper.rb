module DoghousesHelper
  def following_users_collection
    @following_users.map {|f| ["@#{f.screen_name}", f.screen_name]}
  end
end
