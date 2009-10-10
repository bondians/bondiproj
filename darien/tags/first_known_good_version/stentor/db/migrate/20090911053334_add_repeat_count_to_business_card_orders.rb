class AddRepeatCountToBusinessCardOrders < ActiveRecord::Migration
  def self.up
    add_column :business_card_orders, :repeat_count, :integer
  end

  def self.down
    remove_column :business_card_orders, :repeat_count
  end
end
