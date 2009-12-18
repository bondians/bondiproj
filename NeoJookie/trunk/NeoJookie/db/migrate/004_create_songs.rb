class CreateSongs < ActiveRecord::Migration
  def self.up
    create_table :songs do |t|
      t.column :name, :text
      
      t.column :file_path, :text, :null => false
      t.column :file_m_time, :timestamp
      
      t.column :track, :integer
      t.column :year, :integer
      
      t.column :album_id, :integer, :null => false, :default => 1
      t.column :artist_id, :integer, :null => false, :default => 1
      t.column :genre_id, :integer, :null => false, :default => 1
      
      t.column :comments, :text
      
      t.column :fade_in, :boolean, :null => false, :default => true
      t.column :fade_duration, :float
      t.column :volume, :float, :null => false, :default => 0.7
    end
  end

  def self.down
    drop_table :songs
  end
end
