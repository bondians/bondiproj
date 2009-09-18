class AddOrderedToBusinessCards < ActiveRecord::Migration
  def self.up
    add_column :business_cards, :ordered, :boolean
  end

  def self.down
    remove_column :business_cards, :ordered
  end
end
