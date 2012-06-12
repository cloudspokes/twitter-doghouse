class ChangeReleaseDateTimeToDurationMinutesInDoghouse < ActiveRecord::Migration
  def up
    remove_column :doghouses, :release_date_time
    add_column :doghouses, :duration_minutes, :integer
  end

  def down
    remove_column :doghouses, :duration_minutes
    add_column :doghouses, :release_date_time, :datetime
  end
end
