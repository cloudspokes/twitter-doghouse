class SessionsController < ApplicationController
  
  skip_before_filter :user_authenticated
  
  # Recieve twitter omniauth response
  # Create new user if doesn't already exit
  # Log in the authenticated user
  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to app_path
  end
  
  # This action is hit if user hits cancel on Twitter oauth page
  def failure
    redirect_to root_url, alert: 'Twitter authentication denied.'
  end

  # Log out
  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end
