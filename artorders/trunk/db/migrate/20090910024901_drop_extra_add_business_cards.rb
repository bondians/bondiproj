class DropExtraAddBusinessCards < ActiveRecord::Migration
  def self.up
    add_column :business_cards, :extra, :string
    remove_column :business_cards, :extra_line
  end

  def self.down
    add_column :business_cards, :extra_line, :text
    remove_column :business_cards, :extra
  end
end
