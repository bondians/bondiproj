class CreateWorkflows < ActiveRecord::Migration
  def self.up
    create_table :workflows do |t|
      t.string :name
      t.string :note
      t.boolean :completed
      t.date :completed_date
      t.integer :job_id

      t.timestamps
    end
  end

  def self.down
    drop_table :workflows
  end
end
