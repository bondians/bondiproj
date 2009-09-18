class InqPersiphone < ActiveRecord::Migration
  def self.up
      change_table :inquiries do |t|
          t.remove :person_phone
          t.integer :persiphone_id 
      end
  end

  def self.down
      change_table :inquiries do |t|
          t.remove :persiphone_id
          t.integer :person_phone 
      end
  end
end
