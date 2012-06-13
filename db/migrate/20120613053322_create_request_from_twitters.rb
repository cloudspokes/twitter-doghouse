class CreateRequestFromTwitters < ActiveRecord::Migration
  def change
    create_table :request_from_twitters do |t|
      t.string :from_user
      t.string :tweet_id
      t.string :text

      t.timestamps
    end
  end
end
