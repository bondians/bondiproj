class InqArtistsFix < ActiveRecord::Migration
  def self.up
      change_table :inquiries do |t|
          t.remove :artist_recipient
          t.remove :artist_notater
          t.integer :artist_recipient_id 
          t.integer :artist_notater_id 
      end
  end

  def self.down
      change_table :inquiries do |t|
          t.remove :artist_recipient_id
          t.remove :artist_notater_id
          t.integer :artist_recipient 
          t.integer :artist_notater 
      end
  end
end
