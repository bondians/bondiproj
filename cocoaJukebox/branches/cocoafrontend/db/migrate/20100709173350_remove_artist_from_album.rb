class RemoveArtistFromAlbum < ActiveRecord::Migration
  def self.up
    remove_column :albums, :artist_id
  end

  def self.down
    add_column :albums, :artist_id, :integer
  end
end
