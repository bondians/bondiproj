class AddSortToPlentry < ActiveRecord::Migration
  def self.up
    add_column :plentries, :sort, :integer
  end

  def self.down
    remove_column :plentries, :sort
  end
end
