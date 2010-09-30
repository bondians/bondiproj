class CreateAlbumartists < ActiveRecord::Migration
  def self.up
    create_table :albumartists do |t|
      t.references :album
      t.references :artist

      t.timestamps
    end
  end

  def self.down
    drop_table :albumartists
  end
end
