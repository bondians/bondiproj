class CreateSegues < ActiveRecord::Migration
  def self.data
    [
      { :from => 186550, :to => 186548 },
      { :from => 168215, :to => 168216 },
      { :from => 173781, :to => 165365 },
      { :from => 172988, :to => 172989 },
      { :from => 174150, :to => 174153 },
      { :from => 165209, :to => 165210 },
      { :from => 179593, :to => 179594 },
      { :from => 179584, :to => 179585 }
    ]
  end
  
  def self.up
    create_table :segues do |t|
      t.column :song_id, :integer, :null => false
      t.column :segue_to_id, :integer, :null => false
    end
    
    add_index :segues, :song_id, :unique => true
    add_index :segues, :segue_to_id
    
    self.data.each do |d|
      Segue.new do |s|
        s.song_id = d[:from]
        s.segue_to_id = d[:to]
        
        s.save
      end
    end
    
  end

  def self.down
    drop_table :segues
  end
end
