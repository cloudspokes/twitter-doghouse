class CreateCannedTweets < ActiveRecord::Migration
  def change
    create_table :canned_tweets do |t|
      t.string :description
      t.string :text
      t.string :tweet_type

      t.timestamps
    end
    add_index :canned_tweets, :tweet_type
  end
end
