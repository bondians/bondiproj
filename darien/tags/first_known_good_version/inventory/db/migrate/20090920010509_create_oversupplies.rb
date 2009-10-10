class CreateOversupplies < ActiveRecord::Migration
  def self.up
    create_table :oversupplies do |t|
      t.string :name
      t.string :building
      t.timestamps
    end
  end
  
  def self.down
    drop_table :oversupplies
  end
end
