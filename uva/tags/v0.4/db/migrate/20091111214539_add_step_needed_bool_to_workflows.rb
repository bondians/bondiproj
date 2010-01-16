class AddStepNeededBoolToWorkflows < ActiveRecord::Migration
  def self.up
    add_column :workflows, :step_needed, :boolean
  end

  def self.down
    remove_column :workflows, :step_needed
  end
end
