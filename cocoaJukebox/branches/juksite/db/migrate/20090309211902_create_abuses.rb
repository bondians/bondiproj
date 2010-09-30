class CreateAbuses < ActiveRecord::Migration
  def self.up
    create_table :abuses do |t|
      t.text :abuse

      t.timestamps
    end
  end

  def self.down
    drop_table :abuses
  end
end
