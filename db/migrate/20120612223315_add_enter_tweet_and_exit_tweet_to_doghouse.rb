class AddEnterTweetAndExitTweetToDoghouse < ActiveRecord::Migration
  def change
    add_column :doghouses, :enter_tweet, :string

    add_column :doghouses, :exit_tweet, :string

  end
end
