class CreateSongTypes < ActiveRecord::Migration
  def self.up
    create_table :song_types do |t|
      t.string :name
      t.string :description
      t.string :identifier
      t.string :mime_type

      t.timestamps
    end
  end

  def self.down
    drop_table :song_types
  end
end
