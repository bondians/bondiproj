class RemoveGenreFromAlbum < ActiveRecord::Migration
  def self.up
    remove_column :albums, :genre_id
  end

  def self.down
    add_column :albums, :genre_id, :integer
  end
end
