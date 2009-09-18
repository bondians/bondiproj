class CreatePersonPhones < ActiveRecord::Migration
  def self.up
    create_table :person_phones do |t|
      t.integer :person
      t.integer :phone

      t.timestamps
    end
  end

  def self.down
    drop_table :person_phones
  end
end
