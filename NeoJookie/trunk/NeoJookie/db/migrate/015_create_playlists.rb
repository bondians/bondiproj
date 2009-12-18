class CreatePlaylists < ActiveRecord::Migration
  def self.up
    create_table :playlists do |t|
      t.column :user_id, :integer
      t.column :name, :text
    end
    
    create_table :playlists_songs, :id => false do |t|
      t.column :playlist_id, :integer
      t.column :song_id, :integer
    end
    
    add_index :playlists, [:user_id, :name], :unique => true
  end

  def self.down
    drop_table :playlists
    drop_table :playlists_songs
  end
end
