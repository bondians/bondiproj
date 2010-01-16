class ChangeColumnNamesToNewTaksAndTaskTypes < ActiveRecord::Migration
  def self.up
    rename_column :jobs, :task_id, :task_type_id
    rename_column :jobs, :workflow_id, :task_id
    rename_column :tasks, :task_id, :task_type_id
    
  end

  def self.down
    rename_column :jobs, :task_id, :workflow_id
    rename_column :jobs, :task_type_id, :workflow_id
    rename_column :tasks, :task_type_id, :task_id
  end
end
