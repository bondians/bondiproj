class RenameWorkflowsToJobSteps < ActiveRecord::Migration
  def self.up
    rename_table :tasks, :task_types
    rename_table :workflows, :tasks
  end

  def self.down
    rename_table :task_types, :tasks
    rename_table :tasks, :workflows
  end
end
