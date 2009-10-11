class AddExtrasToBc < ActiveRecord::Migration
  def self.up
    add_column :business_cards, :extra_line, :text
  end

  def self.down
    remove_column :business_cards, :extra_line
  end
end
