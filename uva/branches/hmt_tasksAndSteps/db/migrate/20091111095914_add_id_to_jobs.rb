class AddIdToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :job_id, :integer
  end

  def self.down
    remove_column :jobs, :job_id
  end
end
