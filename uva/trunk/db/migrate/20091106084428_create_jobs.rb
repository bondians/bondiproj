class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.string :name
      t.text :description
      t.date :due_date
      t.time :due_time
      t.date :submit_date
      t.string :ordered_by
      t.string :input_person
      t.boolean :auth_sig
      t.integer :department_id
      t.integer :account_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :jobs
  end
end
