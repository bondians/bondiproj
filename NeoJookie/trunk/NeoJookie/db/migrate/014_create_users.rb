class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :name, :text, :null => false
      
      t.column :password_hashed, :text, :null => false
      t.column :password_salt, :text, :null => false
    end
    
    add_index :users, :name, :unique => true
    
    User.new do |u|
      u.name = "deepbondi"
      
      u.password = "pickles"
      u.password_confirmation = "pickles"
      
      u.save
    end
  end

  def self.down
    drop_table :users
  end
end
