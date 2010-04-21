class AddUserToMember < ActiveRecord::Migration
  def self.up
    add_column :members, :user, :integer
  end

  def self.down
    remove_column :members, :user
  end
end
