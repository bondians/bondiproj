class AddThemeToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :theme, :string
  end

  def self.down
    remove_column :settings, :theme
  end
end
