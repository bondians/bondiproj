class CreatePastpaths < ActiveRecord::Migration
  def self.up
    create_table :pastpaths do |t|
      t.references :song
      t.string :file

      t.timestamps
    end
  end

  def self.down
    drop_table :pastpaths
  end
end
