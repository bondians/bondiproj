class AddActiveToPlaylists < ActiveRecord::Migration
  def self.up
    add_column :playlists, :active, :boolean
  end

  def self.down
    remove_column :playlists, :active
  end
end
