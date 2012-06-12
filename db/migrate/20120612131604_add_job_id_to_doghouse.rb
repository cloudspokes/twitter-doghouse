class AddJobIdToDoghouse < ActiveRecord::Migration
  def change
    add_column :doghouses, :job_id, :integer

  end
end
