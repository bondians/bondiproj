class WtfJobs < ActiveRecord::Migration
  def self.up
    # rename_column :jobs, :workflow_id, :task_id
    # this should have been done in 
    # 20100116214241_change_column_names_to_new_taks_and_task_types.rb
    # WTF!
  end

  def self.down
    # nothing to undo that shouldn't have been done already
    
  end
end
