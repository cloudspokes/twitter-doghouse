class HomeController < ApplicationController
  
  # Don't need to be logged in to go to main page
  skip_before_filter :user_authenticated
  
  def index
    # Make sure @current_user is set
    current_user
  end
  
end