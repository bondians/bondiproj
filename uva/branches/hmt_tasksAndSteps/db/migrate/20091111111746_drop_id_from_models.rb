class DropIdFromModels < ActiveRecord::Migration
  def self.up
    remove_column :jobs, :job_id
    remove_column :tasks, :task_id
    remove_column :departments, :department_id
    remove_column :accounts, :account_id
  end

  def self.down
    add_column :jobs, :job_id, :integer
    add_column :tasks, :task_id, :integer
    add_column :departments, :department_id, :integer
    add_column :accounts, :account_id, :integer
  end
end
