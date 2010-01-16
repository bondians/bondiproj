class AddOrderToWorkflows < ActiveRecord::Migration
  def self.up
    add_column :workflows, :order, :integer
  end

  def self.down
    remove_column :workflows, :order
  end
end
