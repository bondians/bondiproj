class CreatePlentries < ActiveRecord::Migration
  def self.up
    create_table :plentries do |t|
      t.references :song
      t.references :playlist

      t.timestamps
    end
  end

  def self.down
    drop_table :plentries
  end
end
