class AddActiveToApids < ActiveRecord::Migration
  def self.up
    add_column :apids, :active, :boolean
  end

  def self.down
    remove_column :apids, :active
  end
end
