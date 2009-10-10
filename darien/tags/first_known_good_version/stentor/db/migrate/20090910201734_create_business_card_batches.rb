class CreateBusinessCardBatches < ActiveRecord::Migration
  def self.up
    create_table :business_card_batches do |t|
      t.integer :quantity
      t.boolean :printed
      t.string :batch_name
      t.timestamps
    end
  end
  
  def self.down
    drop_table :business_card_batches
  end
end
