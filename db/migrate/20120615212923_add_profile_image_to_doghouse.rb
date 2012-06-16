class AddProfileImageToDoghouse < ActiveRecord::Migration
  def change
    add_column :doghouses, :profile_image, :string

  end
end
