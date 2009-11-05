class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.string :name
      t.text :description
      t.date :submit_date
      t.date :due_date
      t.string :entry_person
      t.string :acct_number
      t.string :requester
      t.string :department
      t.boolean :auth_sig
      t.string :uno_path
      t.string :copier_name
      t.timestamps
    end
  end
  
  def self.down
    drop_table :jobs
  end
end
