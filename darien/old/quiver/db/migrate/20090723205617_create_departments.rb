class CreateDepartments < ActiveRecord::Migration
  def self.up
    create_table :departments do |t|
      t.string :name
      t.string :phone_number
      t.string :phone_area_code
      t.string :fax_number
      t.string :fax_area_code
      t.string :address
      t.string :city
      t.string :state
      t.string :zip_code

      t.timestamps
    end
  end

  def self.down
    drop_table :departments
  end
end
