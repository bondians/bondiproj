class AddFileToPlentry < ActiveRecord::Migration
  def self.up
    add_column :plentries, :file, :text
  end

  def self.down
    remove_column :plentries, :file
  end
end