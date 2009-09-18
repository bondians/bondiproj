class CreateArtists < ActiveRecord::Migration
  def self.up
    create_table :artists do |t|
      t.string :name
      t.string :one_color
      t.string :two_color
      t.string :three_color

      t.timestamps
    end
  end

  def self.down
    drop_table :artists
  end
end
