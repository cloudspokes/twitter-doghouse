class HomeController < ApplicationController
  
  skip_before_filter :user_authenticated
  
  def index
    current_user
  end
  
end