class CreateBusinessCardOrders < ActiveRecord::Migration
  def self.up
    create_table :business_card_orders do |t|
      t.integer :quantity
      t.integer :business_card_batch_id
      t.boolean :reprint
      t.integer :business_card_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :business_card_orders
  end
end
