class DoghousesController < ApplicationController
  
  before_filter :doghouse_belongs_to_user, only: [:update, :destroy, :release]
  
  # This is the main app page
  def index
    if current_user
      @new_doghouse = Doghouse.new duration_minutes_multiplier: 1
      @following_users = current_user.get_following_users
      @canned_enter_tweets = CannedTweet.enter_tweets
      @canned_exit_tweets = CannedTweet.exit_tweets
      @active_doghouses = get_active_doghouses
    end
  end

  # Create a new doghouse entry via ajax call
  def create
    @doghouse = current_user.doghouses.build(params[:doghouse])
    @error = true unless @doghouse.save
    @active_doghouses = get_active_doghouses
    respond_to do |format|
      format.js
    end
  end

  # Update existing doghouse entry via ajax call
  def update
    @error = true unless @doghouse.update_attributes(params[:doghouse])
    @active_doghouses = get_active_doghouses
    respond_to do |format|
      format.js
    end
  end

  # Destroy existing doghouse entry via ajax call
  # This removes user from doghouse and doesn't refollow or send exit tweet
  def destroy
    @doghouse.destroy
    @active_doghouses = get_active_doghouses
    respond_to do |format|
      format.js
    end
  end
  
  # Release user from doghouse via ajax call
  # This removes user from doghouse, refollows them and sends the exit tweet
  def release
    @doghouse.release_now!
    @active_doghouses = get_active_doghouses
    respond_to do |format|
      format.js
    end
  end
  
  private
  
    # Returns the logged in user's active doghouse entries paginated
    def get_active_doghouses
      current_user.active_doghouses.page(params[:page]).per(DOGHOUSES_PER_PAGE)
    end
    
    # Only allow user to proceed if they own the doghouse entry that they are trying to interact with
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
