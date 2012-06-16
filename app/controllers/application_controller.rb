class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :user_authenticated
  
  # Get the current logged in user and set the @current_user variable if not set yet
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  private
    
    # Filter that goes to root page if user if not logged in
    def user_authenticated
      redirect_to root_url, alert: 'You must be logged in to go here' unless current_user
    end
end
