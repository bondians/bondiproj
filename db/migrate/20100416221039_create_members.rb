class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.string :name
      t.integer :level
      t.string :racepic
      t.string :classpic
      t.string :guild
      t.integer :health
      t.integer :armor
      t.integer :strength
      t.integer :stamina
      t.integer :agility
      t.integer :spirit
      t.integer :intellect

      t.timestamps
    end
  end

  def self.down
    drop_table :members
  end
end
