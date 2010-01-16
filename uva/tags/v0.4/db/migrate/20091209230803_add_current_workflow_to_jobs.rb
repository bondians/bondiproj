class AddCurrentWorkflowToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :workflow_id, :integer
    add_column :jobs, :completed, :boolean
  end

  def self.down
    remove_column :jobs, :completed
    remove_column :jobs, :workflow_id
  end
end
