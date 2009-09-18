class PersiponeFixer < ActiveRecord::Migration
  def self.up
      change_table :persiphones do |t|
          t.remove :person
          t.remove :person
          t.integer :person_id 
          t.integer :phone_id 
      end
  end

  def self.down
      change_table :persiphones do |t|
          t.remove :person_id
          t.remove :person_id
          t.integer :person 
          t.integer :phone 
      end
  end
end
