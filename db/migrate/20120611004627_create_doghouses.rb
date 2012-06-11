class CreateDoghouses < ActiveRecord::Migration
  def change
    create_table :doghouses do |t|
      t.integer :user_id
      t.string :screen_name
      t.datetime :release_date_time
      t.boolean :is_released

      t.timestamps
    end
    add_index :doghouses, :user_id
  end
end
