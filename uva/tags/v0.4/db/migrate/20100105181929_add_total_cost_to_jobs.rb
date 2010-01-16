class AddTotalCostToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :total_cost, :decimal, :precision => 9, :scale => 2
  end

  def self.down
    remove_column :jobs, :total_cost
  end
end
