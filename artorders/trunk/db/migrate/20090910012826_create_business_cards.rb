class CreateBusinessCards < ActiveRecord::Migration
  def self.up
    create_table :business_cards do |t|
      t.string :name
      t.string :title
      t.string :title_line_2
      t.string :school
      t.string :school_line_2
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.string :fax
      t.string :email
      t.boolean :altEd
      t.boolean :distinguished_school
      t.timestamps
    end
  end
  
  def self.down
    drop_table :business_cards
  end
end
