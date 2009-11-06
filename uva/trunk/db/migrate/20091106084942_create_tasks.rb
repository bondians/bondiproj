class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :name
      t.string :note
      t.boolean :completed
      t.date :completed_date

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
