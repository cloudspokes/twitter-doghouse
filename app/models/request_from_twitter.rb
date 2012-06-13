class RequestFromTwitter < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :tweet_id, :text
  
  def self.handle_incoming_requests
    requests = Twitter.search SEARCH_QUERY, result_type: 'recent', since_id: RequestFromTwitter.last.try(:tweet_id)
    requests.reverse_each do |request|
      user = User.find_by_nickname request.from_user
      next unless user
      text_split = request.text.split ' '
      next if text_split.length < 3
      next unless text_split[0] == SEARCH_QUERY # Must start with @TwitDoghouse
      next unless text_split[2].to_i > 0 # duration_minutes
      next unless Twitter.friendship(request.from_user, text_split[1]).source.following # screen_name to add to doghouse
      request_from_twitter = user.request_from_twitters.create(tweet_id: request.id, text: request.text)
      user.doghouses.create({screen_name: text_split[1], duration_minutes: text_split[2].to_i, request_from_twitter_id: request_from_twitter.id}, as: :safe_code)
    end
  end
end
