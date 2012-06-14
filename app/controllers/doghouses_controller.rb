class DoghousesController < ApplicationController
  skip_before_filter :user_authenticated, only: :index
  before_filter :set_locals, only: [:new, :create]
  
  def index
    @doghouses = current_user.doghouses if current_user
  end

  def show
    @doghouse = Doghouse.find(params[:id])
  end

  def new
    @doghouse = Doghouse.new
  end

  def edit
    @doghouse = Doghouse.find(params[:id])
  end

  def create
    @doghouse = current_user.doghouses.build(params[:doghouse])
    if @doghouse.save
      redirect_to @doghouse, notice: 'Doghouse was successfully created.'
    else
      render action: "new"
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
  
  private
  
    def set_locals
      @following_users = current_user.get_following_users
      @canned_enter_tweets = CannedTweet.enter_tweets
      @canned_exit_tweets = CannedTweet.exit_tweets
    end
end
