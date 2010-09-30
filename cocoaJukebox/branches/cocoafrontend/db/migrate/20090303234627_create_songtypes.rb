class CreateSongtypes < ActiveRecord::Migration
  def self.up
    create_table :songtypes do |t|
      t.string :name
      t.string :description
      t.string :identifier
      t.string :mime_type

      t.timestamps
    end
  end

  def self.down
    drop_table :songtypes
  end
end
