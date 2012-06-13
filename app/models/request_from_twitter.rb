class RequestFromTwitter < ActiveRecord::Base
  MINUTES_CHAR = 'm'
  HOURS_CHAR = 'h'
  DAYS_CHAR = 'd'
  DURATION_TYPES = [MINUTES_CHAR, HOURS_CHAR, DAYS_CHAR]
  DURATION_MINUTES_MULTIPLIER_MAP = {"#{MINUTES_CHAR}" => 1, "#{HOURS_CHAR}" => MINUTES_IN_HOUR, "#{DAYS_CHAR}" => MINUTES_IN_DAY}
  
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
      duration = text_split[2].chop #Should be of form 29m. This removes the last char.
      duration_type = text_split[2][-1] #Last char
      next unless duration.to_i > 0
      next unless DURATION_TYPES.include?(duration_type)
      duration_minutes = DURATION_MINUTES_MULTIPLIER_MAP[duration_type] * duration.to_i
      next unless Twitter.friendship(request.from_user, text_split[1]).source.following # screen_name to add to doghouse
      enter_tweet = text_split[3..-1].join ' '
      request_from_twitter = user.request_from_twitters.create(tweet_id: request.id, text: request.text)
      user.doghouses.create({screen_name: text_split[1], duration_minutes: duration_minutes, enter_tweet: enter_tweet, request_from_twitter_id: request_from_twitter.id}, as: :safe_code)
    end
  end
end
