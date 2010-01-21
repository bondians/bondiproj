class UpdateTaskTypes < ActiveRecord::Migration
  def self.up
    add_column :task_types, :required_task, :boolean
    add_column :task_types, :quick_copy_default_task, :boolean
    add_column :task_types, :full_job_default_task, :boolean
  end

  def self.down
    remove_column :task_types, :required_task
    remove_column :task_types, :quick_copy_default_task
    remove_column :task_types, :full_job_default_task
  end
end
