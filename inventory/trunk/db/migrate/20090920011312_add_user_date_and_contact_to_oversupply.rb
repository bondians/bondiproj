class AddUserDateAndContactToOversupply < ActiveRecord::Migration
  def self.up 
      change_table :oversupplies do |t|
         t.date :user_date
         t.string :contact 
      end
  end

  def self.down  
      change_table :oversupplies do |t|
         t.remove :user_date
         t.remove :contact 
      end
  end
end
