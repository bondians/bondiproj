class CreateGraphicArtsPeople < ActiveRecord::Migration
  def self.up
    create_table :graphic_arts_people do |t|
      t.string :name
      t.string :highlight_color_one
      t.string :highlight_color_two
      t.string :highlight_color_three

      t.timestamps
    end
  end

  def self.down
    drop_table :graphic_arts_people
  end
end
