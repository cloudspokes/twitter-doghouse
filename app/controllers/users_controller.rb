class UsersController < ApplicationController
  # Get a list of ids of the people the user follows on twitter
  def get_following_ids
    user = User.find(params[:user_id])
    following_ids = user.get_following_ids
    respond_to do |format|
      format.json {render json: following_ids}
    end
  end
  
  # Get a list of twitter usernames from a list of twitter ids
  def get_screen_names
    ids = params[:ids].map {|id| id.to_i}
    screen_names = User.get_twitter_screen_names ids
    respond_to do |format|
      format.json {render json: screen_names}
    end
  end
end