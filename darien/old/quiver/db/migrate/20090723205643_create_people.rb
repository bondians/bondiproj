class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :last_name
      t.string :first_name
      t.string :middle_name
      t.string :alternate_last_name
      t.string :email_name
      t.string :email_domain
      t.integer :department_id
      t.datetime :created_on

      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end
