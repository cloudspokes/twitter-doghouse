class ChangeFromUserInRequestToUserId < ActiveRecord::Migration
  def change
    remove_column :request_from_twitters, :from_user
    add_column :request_from_twitters, :user_id, :integer
    add_column :doghouses, :request_from_twitter_id, :integer
    add_index :request_from_twitters, :user_id
    add_index :doghouses, :request_from_twitter_id
  end
end
