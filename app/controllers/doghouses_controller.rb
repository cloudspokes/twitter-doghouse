class DoghousesController < ApplicationController
  
  before_filter :doghouse_belongs_to_user, only: [:update, :destroy, :release]
  
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
    @error = true unless @doghouse.update_attributes(params[:doghouse])
    @active_doghouses = get_active_doghouses
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @doghouse.destroy
    @active_doghouses = get_active_doghouses
    respond_to do |format|
      format.js
    end
  end
  
  def release
    @doghouse.release_now!
    @active_doghouses = get_active_doghouses
    respond_to do |format|
      format.js
    end
  end
  
  private
  
    def get_active_doghouses
      current_user.active_doghouses.page(params[:page]).per(DOGHOUSES_PER_PAGE)
    end
    
    def doghouse_belongs_to_user
      @doghouse = Doghouse.find(params[:id])
      unless @doghouse.user == current_user
        @error = true
        respond_to do |format|
          format.js
        end
      end
    end
end
