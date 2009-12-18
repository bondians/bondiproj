class AddJukeboxPlaylistSupport < ActiveRecord::Migration
  def self.data
    [
      { :user => "deepbondi", :name => "jookie",    :jb => true },
      { :user => "jukebox",   :name => "requests",  :jb => false },
      { :user => "jukebox",   :name => "random",    :jb => false },
      { :user => "jukebox",   :name => "playing",   :jb => false },
    ]
  end
  
  def self.up
    add_column :playlists, :jukebox_source, :boolean, :null => false, :default => false
    
    jukebox_user = User.new do |u|
      u.name = "jukebox"
      
      u.password = "pickles"
      u.password_confirmation = "pickles"
      
      u.save
    end
    
    self.data.each do |d|
      Playlist.new do |p|
        p.user = User.find_by_name(d[:user])
        p.name = d[:name]
        p.jukebox_source = d[:jb]
        
        p.save
      end
    end
  end

  def self.down
    jb = User.find_by_name("jukebox")
    
    Playlist.find_all(:user_id => jb.id).map(&:destroy)
    jb.destroy

    remove_column :playlists, :jukebox_source
  end
end
