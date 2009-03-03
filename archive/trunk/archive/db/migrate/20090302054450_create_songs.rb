class CreateSongs < ActiveRecord::Migration
  def self.up
    create_table :songs do |t|
      t.string :title
      t.integer :track
      t.integer :year
      t.references :album
      t.references :artist
      t.references :genre
      t.text :comments
      t.integer :size
      t.integer :pre_id
      t.integer :post_id
      t.float :fade_duration, :default => -1
      t.float :volume, :default => 0.7
      t.boolean :fade_in, :default => true
      t.integer :user_id
      t.integer :archive_number
      t.text :file
      t.references :song_type

      t.timestamps
    end
  end

  def self.down
    drop_table :songs
  end
end
