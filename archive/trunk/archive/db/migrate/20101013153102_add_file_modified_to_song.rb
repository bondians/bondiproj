class AddFileModifiedToSong < ActiveRecord::Migration
  def self.up
    add_column :songs, :filemod, :datetime
  end

  def self.down
    remove_column :songs, :filemod
  end
end
