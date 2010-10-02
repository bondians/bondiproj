class CreateCurrentsongs < ActiveRecord::Migration
  def self.up
    create_table :currentsongs do |t|
      t.references :song

      t.timestamps
    end
  end

  def self.down
    drop_table :currentsongs
  end
end
