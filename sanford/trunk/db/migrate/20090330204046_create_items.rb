class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :description
      t.string :make
      t.string :number
      t.integer :qty
      t.references :condition
      t.references :submission

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
