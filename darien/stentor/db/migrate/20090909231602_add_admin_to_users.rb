class AddAdminToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.boolean :super_admin
      t.boolean :admin
      t.boolean :user
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :super_admin
      t.remove :admin
      t.remove :user
    end
  end
end
