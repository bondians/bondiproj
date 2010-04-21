class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.integer :number
      t.integer :size
      t.string :identity

      t.timestamps
    end
  end

  def self.down
    drop_table :teams
  end
end
