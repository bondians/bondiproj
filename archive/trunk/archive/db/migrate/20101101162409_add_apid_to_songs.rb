class AddApidToSongs < ActiveRecord::Migration
  def self.up
    add_column :songs, :apid_id, :integer
  end

  def self.down
    remove_column :songs, :apid_id
  end
end
