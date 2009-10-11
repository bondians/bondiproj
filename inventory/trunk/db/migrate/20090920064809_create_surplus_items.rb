class CreateSurplusItems < ActiveRecord::Migration
  def self.up
    create_table :surplus_items do |t|
      t.string :description
      t.string :make_model
      t.string :inventory_id_tag_number
      t.integer :quantity
      t.string :condition_code
      t.timestamps
    end
  end
  
  def self.down
    drop_table :surplus_items
  end
end
