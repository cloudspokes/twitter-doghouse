class DoghousesController < ApplicationController
  skip_before_filter :user_authenticated, only: :index
  
  def index
    if current_user
      @new_doghouse = Doghouse.new duration_minutes_multiplier: 1
      @following_users = current_user.get_following_users
      @canned_enter_tweets = CannedTweet.enter_tweets
      @canned_exit_tweets = CannedTweet.exit_tweets
      @active_doghouses = get_active_doghouses
    end
  end

  def create
    @doghouse = current_user.doghouses.build(params[:doghouse])
    @error = true unless @doghouse.save
    @active_doghouses = get_active_doghouses
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
    Doghouse.find(params[:id]).destroy
    @active_doghouses = get_active_doghouses
    respond_to do |format|
      format.js
    end
  end
  
  def release
    Doghouse.find(params[:id]).release_now!
    @active_doghouses = get_active_doghouses
    respond_to do |format|
      format.js
    end
  end
  
  private
  
    def get_active_doghouses
      current_user.active_doghouses.page(params[:page]).per(DOGHOUSES_PER_PAGE)
    end
end
