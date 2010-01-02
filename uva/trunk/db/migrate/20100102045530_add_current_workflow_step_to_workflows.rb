class AddCurrentWorkflowStepToWorkflows < ActiveRecord::Migration
  def self.up
    add_column :workflows, :task_id, :integer
  end

  def self.down
    remove_column :workflows, :task_id
  end
end
