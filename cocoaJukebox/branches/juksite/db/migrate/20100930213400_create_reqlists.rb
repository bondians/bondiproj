class CreateReqlists < ActiveRecord::Migration
  def self.up
    create_table :reqlists do |t|
      t.references :song
      t.integer :sort

      t.timestamps
    end
  end

  def self.down
    drop_table :reqlists
  end
end
