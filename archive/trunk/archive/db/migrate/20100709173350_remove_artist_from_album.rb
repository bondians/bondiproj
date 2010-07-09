class RemoveArtistFromAlbum < ActiveRecord::Migration
  def self.up
    remove_column :albums, :artist
  end

  def self.down
    add_column :albums, :artist, :integer
  end
end
