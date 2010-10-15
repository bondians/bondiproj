class CreateCulls < ActiveRecord::Migration
  def self.up
    create_table :culls do |t|
      t.file :string
      t.reason :text

      t.timestamps
    end
  end

  def self.down
    drop_table :culls
  end
end
