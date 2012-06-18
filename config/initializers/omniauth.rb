Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, TWITTER_KEY, TWITTER_SECRET
  
  # Put this in because of this bug: https://github.com/intridea/omniauth/issues/616
  # Basically deals with issue if user clicks cancel on Twitter oauth
  class NonExplodingFailureEndpoint < OmniAuth::FailureEndpoint
    def call
      redirect_to_failure
    end
  end

  OmniAuth.config.on_failure = NonExplodingFailureEndpoint
end