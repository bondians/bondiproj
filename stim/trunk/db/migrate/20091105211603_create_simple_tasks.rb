class CreateSimpleTasks < ActiveRecord::Migration
  def self.up
    create_table :simple_tasks do |t|
      t.string :name
      t.string :note
      t.datetime :date_completed
      t.boolean :completed

      t.timestamps
    end
  end

  def self.down
    drop_table :simple_tasks
  end
end
