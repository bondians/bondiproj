class CreateApids < ActiveRecord::Migration
  def self.up
    create_table :apids do |t|
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :apids
  end
end
