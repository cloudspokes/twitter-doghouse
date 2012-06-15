class DoghousesController < ApplicationController
  skip_before_filter :user_authenticated, only: :index
  
  def index
    if current_user
      @new_doghouse = Doghouse.new duration_minutes_multiplier: 1
      @following_users = current_user.get_following_users
      @canned_enter_tweets = CannedTweet.enter_tweets
      @canned_exit_tweets = CannedTweet.exit_tweets
      @doghouses = current_user.doghouses
    end
  end

  def create
    @doghouse = current_user.doghouses.build(params[:doghouse])
    @error = true unless @doghouse.save
    respond_to do |format|
      format.js
    end
  end

  def update
    @doghouse = Doghouse.find(params[:id])
    if @doghouse.update_attributes(params[:doghouse])
      redirect_to @doghouse, notice: 'Doghouse was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @doghouse = Doghouse.find(params[:id])
    @doghouse.destroy
    redirect_to doghouses_url
  end
end
