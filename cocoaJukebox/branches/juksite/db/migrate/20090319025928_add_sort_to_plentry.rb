class AddSortToPlentry < ActiveRecord::Migration
  def self.up
    add_column :plentries, :idx, :integer
  end

  def self.down
    remove_column :plentries, :idx
  end
end
