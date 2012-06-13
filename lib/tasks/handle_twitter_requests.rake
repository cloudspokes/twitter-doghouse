desc "This task is called by the Heroku scheduler add-on"
task :handle_twitter_requests => :environment do
  RequestFromTwitter.handle_incoming_requests
end