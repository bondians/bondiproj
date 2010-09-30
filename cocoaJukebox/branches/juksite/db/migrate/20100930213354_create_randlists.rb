class CreateRandlists < ActiveRecord::Migration
  def self.up
    create_table :randlists do |t|
      t.references :song
      t.integer :sort

      t.timestamps
    end
  end

  def self.down
    drop_table :randlists
  end
end
