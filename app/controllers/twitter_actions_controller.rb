class TwitterActionsController < ApplicationController
  def unfollow
    Twitter.unfollow(params[:screen_name])
    redirect_to root_url, notice: "#{params[:screen_name]} successfully unfollowed"
  end
end