class CreateIntros < ActiveRecord::Migration
  class Intro < ActiveRecord::Base
  end
  
  def self.up
    create_table :intros do |t|
      t.column :song_id, :integer, :null => false
      t.column :intro_id, :integer, :null => false
    end
    
    add_index :intros, :song_id, :unique => true
    add_index :intros, :intro_id
    
    # only one intro in the DB presently
    Intro.new do |i|
      i.song_id = 186548;
      i.intro_id = 186550;
      
      i.save;
    end
  end

  def self.down
    drop_table :intros
  end
end
