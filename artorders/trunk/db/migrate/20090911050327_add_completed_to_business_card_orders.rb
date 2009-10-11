class AddCompletedToBusinessCardOrders < ActiveRecord::Migration
  def self.up
    add_column :business_card_orders, :completed, :boolean
  end

  def self.down
    remove_column :business_card_orders, :completed
  end
end
