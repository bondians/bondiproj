class CreateUsertimes < ActiveRecord::Migration
  def self.up
    create_table :usertimes do |t|
      t.references :user
      t.integer :keytime
      t.boolean :sun
      t.boolean :mon
      t.boolean :tue
      t.boolean :wed
      t.boolean :thu
      t.boolean :fri
      t.boolean :sat

      t.timestamps
    end
  end

  def self.down
    drop_table :usertimes
  end
end
