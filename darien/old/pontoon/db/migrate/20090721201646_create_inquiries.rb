class CreateInquiries < ActiveRecord::Migration
  def self.up
    create_table :inquiries do |t|
      t.integer :person_id
      t.integer :department_id
      t.text :message_text
      t.integer :person_phone
      t.integer :graphic_arts_person
      t.datetime :created_on

      t.timestamps
    end
  end

  def self.down
    drop_table :inquiries
  end
end
