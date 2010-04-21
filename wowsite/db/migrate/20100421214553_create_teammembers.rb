class CreateTeammembers < ActiveRecord::Migration
  def self.up
    create_table :teammembers do |t|
      t.references :team
      t.references :member

      t.timestamps
    end
  end

  def self.down
    drop_table :teammembers
  end
end
