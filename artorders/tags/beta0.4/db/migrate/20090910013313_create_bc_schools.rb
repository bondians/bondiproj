class CreateBcSchools < ActiveRecord::Migration
  def self.up
    create_table :bc_schools do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :default_phone
      t.string :default_fax
      t.timestamps
    end
  end
  
  def self.down
    drop_table :bc_schools
  end
end
