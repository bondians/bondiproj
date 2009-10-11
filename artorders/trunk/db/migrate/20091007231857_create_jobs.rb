class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.string :name
      t.string :description
      t.datetime :due_date
      t.integer :account_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :jobs
  end
end
