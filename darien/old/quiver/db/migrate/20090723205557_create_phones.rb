class CreatePhones < ActiveRecord::Migration
  def self.up
    create_table :phones do |t|
      t.string :phone_number
      t.string :phone_area_code
      t.integer :phone_type_id

      t.timestamps
    end
  end

  def self.down
    drop_table :phones
  end
end
