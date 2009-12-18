class Jukebox
  @jukebox_user ||= User.find_by_name("jukebox")
  
  ############################################
  # Playlist access & now-playing management
  #
  
  def self.playing
  self.rawPlayingList.songs[0]
  end
  
  def self.playing=(song)
    list = self.rawPlayingList
    if song then
      list.songs = [song]
    else
      list.songs = []
    end
    
    list.save
  end
  
  def self.playingList
    self.rawPlayingList.songs
  end
  
  def self.requestList
    self.rawRequestList.songs
  end
  
  def self.randomList
    self.rawRandomList.songs
  end
  
  ############################
  # generic queue management
  
  def self.queued?(list, song)
    list.songs.any? do |queued|
      queued.id == song.id
    end
  end
  
  # check whether a song is queued in either list
  def self.queuedAnywhere?(song)
    self.queued?(self.rawRandomList, song) or self.queued?(self.rawRequestList, song)
  end
  
  def self.queue!(list, *songs)
    queued = []
    
    songs.each do |song|
      unless song.nil? or self.queued?(list, song)
        list.songs << song
        queued << song
      end
    end
    
    list.save
    
    return queued
  end
  
  def self.dequeue!(list, *songs)
    dequeued = []
    
    songs.each do |song|
      unless song.nil?
        if list.songs.delete(song)
          dequeued << song
        end
      end
    end
    
    list.save
    
    return dequeued
  end
  
  def self.dequeueFirst!(list)
    if list.songs.count > 0
      song = list.songs[0]
      list.songs.delete(song)
      
      list.save
      
      return song
    else
      return nil
    end
  end
  
  
  ##################################
  # request management
  #
  
  def self.request_id!(*ids)
    songs = Song.find_all(:id => ids)
    self.request!(*songs)
  end
  
  def self.request!(*songs)
    queued = self.queue!(self.rawRequestList, *songs)
    self.dequeue!(self.rawRandomList, *queued)
    
    queued
  end
  
  ###################################
  # random list managament
  #
  
  # playlists that the jukebox will randomly play from
  def self.randomSources
    Playlist.find_all(:jukebox_source => true)
  end
  
  def self.resetSources(playlists)
    Playlist.find_all.each do |p|
      p.jukebox_source = false
      p.save
    end
    
    if playlists
      playlists.each do |p|
        p.jukebox_source = true
        p.save
      end
    end
  end
  
  # all songs eligible for random selection
  def self.randomSongs
    candidates = self.randomSources.map do |src|
      src.songs
    end
    
    candidates.flatten!
    candidates.uniq!
    
    candidates
  end
  
  # pick one song
  def self.randomSong
    candidates = self.randomSongs
    n = candidates.length
    
    candidates[self.random_number % n]
  end
  
  #check whether a song is playing
  def self.playing?(song=nil)
    if song then
      self.playing == song
    else
      self.playing != nil
    end
  end
    
  # fill the random list to at least 'count' items, bailing after 'bail' failures
  # (dupes are never added, nor are songs currently playing)
  def self.fillRandom!(count = 30, bail = 10)
    list = self.rawRandomList
    
    while (bail > 0 and list.songs.count < count)
      song = self.randomSong
      if self.queuedAnywhere?(song) or self.playing?(song)
        bail -= 1
      else
        list.songs << song
      end
    end
    
    list.save
  end
  
  ##########################
  # now-playing management
  
  # used for segues & intros only; discard current "playing" and return next
  def self.getNextPlaying!
    self.dequeueFirst!(self.rawPlayingList)
    return playing
  end
  
  def self.getRequest!
    self.dequeueFirst!(self.rawRequestList)
  end
  
  def self.getRandom!
    self.fillRandom!(1, 100)
    self.dequeueFirst!(self.rawRandomList)
  end
  
  def self.next!
    song = self.getNextPlaying!
    
    song ||= self.getRequest!
    song ||= self.getRandom!
    
    if playing.nil?
      song.closure.each do |s|
        self.rawPlayingList.songs << s
      end
    end
    
    self.playing
  end
  
  
#  private
  
  # find a std lib for this ....
  def self.random_number
    t = Time.now.to_f / (Time.now.to_f % Time.now.to_i)
    random_seed = t * 1103515245 + 12345;
    (random_seed / 65536) % 32768;
  end
  
  #############################
  # private playlist accessors; enforces currentness
  
  def self.rawPlayingList
    Playlist.find(:first, 
      :conditions => {:name => "playing", :user_id => @jukebox_user.id})
  end
  
  def self.rawRequestList
    @rawRequestList ||= Playlist.find(:first,
      :conditions => {:name => "requests", :user_id => @jukebox_user.id})
    
    @rawRequestList.reload
    @rawRequestList
  end
  
  def self.rawRandomList
    @rawRandomList ||= Playlist.find(:first,
      :conditions => {:name => "random", :user_id => @jukebox_user.id})
    
    @rawRandomList.reload
    @rawRandomList
  end
end