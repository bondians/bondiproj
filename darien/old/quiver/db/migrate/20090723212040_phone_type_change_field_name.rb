class PhoneTypeChangeFieldName < ActiveRecord::Migration
  def self.up
      change_table :phone_types do |t|
         t.remove :phone_type
         t.string :kind 
      end
  end

  def self.down
      change_table :phone_types do |t|
         t.remove :kind
         t.string :phone_type 
      end
  end
end
