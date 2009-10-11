class CreateSurplus < ActiveRecord::Migration
  def self.up
    create_table :surplus do |t|
      t.string :from
      t.string :building_number
      t.string :contact
      t.timestamps
    end
  end
  
  def self.down
    drop_table :surplus
  end
end
