class CreateFinders < ActiveRecord::Migration
  def self.up
    create_table :finders do |t|
      t.datetime :started
      t.datetime :completed
      t.integer :added
      t.integer :removed
      t.boolean :success

      t.timestamps
    end
  end

  def self.down
    drop_table :finders
  end
end
