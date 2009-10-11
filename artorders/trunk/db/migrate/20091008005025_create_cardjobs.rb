class CreateCardjobs < ActiveRecord::Migration
  def self.up
    create_table :cardjobs do |t|
      t.integer :job_id
      t.integer :business_card_order_id
      t.timestamps
    end
  end

  def self.down
    drop_table :cardjobs
  end
end
