class CreateCulls < ActiveRecord::Migration
  def self.up
    create_table :culls do |t|
      t.string :file
      t.text :reason

      t.timestamps
    end
  end

  def self.down
    drop_table :culls
  end
end
