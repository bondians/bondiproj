class CreatePersiphones < ActiveRecord::Migration
  def self.up
    create_table :persiphones do |t|
      t.integer :person
      t.integer :phone

      t.timestamps
    end
  end

  def self.down
    drop_table :persiphones
  end
end
