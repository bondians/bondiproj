class AddOversupplyIdToSurplusItems < ActiveRecord::Migration
  def self.up
      change_table :surplus_items do |t| 
          t.integer :oversupply_id
      end
  end

  def self.down
      change_table :surplus_items do |t| 
           t.remove :oversupply_id
      end
  end
end
