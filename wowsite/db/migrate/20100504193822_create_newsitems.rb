class CreateNewsitems < ActiveRecord::Migration
  def self.up
    create_table :newsitems do |t|
      t.string :title
      t.text :body
      t.references :newsfeed
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :newsitems
  end
end
