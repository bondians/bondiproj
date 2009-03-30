class CreateRequests < ActiveRecord::Migration
  def self.up
    create_table :requests do |t|
      t.references :user
      t.string :name
      t.string :department
      t.string :bldg
      t.references :status
      t.references :summary

      t.timestamps
    end
  end

  def self.down
    drop_table :requests
  end
end
