class AddUserToMember < ActiveRecord::Migration
  def self.up
    add_column :members, :user, :references
  end

  def self.down
    remove_column :members, :user
  end
end
