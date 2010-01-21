class AddTaskDefualtOrderToTaskTypes < ActiveRecord::Migration
  def self.up
    add_column :task_types, :default_task_order, :integer
  end

  def self.down
    remove_column :task_types, :default_task_order
  end
end
