class WowInterface
  
  REALM = 'Coilfang'
  GUILDS = ["Alliance Pwners", "Alliance Pwners II"]
  MINIMUMLEVEL = 80
  
  
  def initialize
    @api = Wowr::API.new(:realm => REALM)
  end
  
  def api
    @api
  end
  
  def search(name)
    results = @api.search_characters name
    results.select {|dude| dude.realm == REALM}
  end
  
  def getAttributes(data)
    attributes = {}
    attributes[:name] = data.name
    attributes[:level] = data.level
    attributes[:racepic] = data.race_icon.gsub("images","_images")
    attributes[:classpic] = data.class_icon.gsub("images","_images")
    attributes[:guild] = data.guild
    attributes[:health] = data.health
    attributes[:armor] = data.defenses.armor.effective
    attributes[:strength] = data.str.effective
    attributes[:stamina] = data.sta.effective
    attributes[:agility] = data.agi.effective
    attributes[:spirit] = data.spi.effective
    attributes[:intellect] = data.int.effective
    return attributes
  end

  def updateMembers
    @api.clear_cache
    @api.debug = true
    data = {}
    data[:updated] = []
    timer = Time.now
    armoryData = {}

    GUILDS.each do |guild|
      @api.guild_name = guild
      g = @api.get_guild
      armoryData.merge!(g.members.reject {|k,v| v.level < MINIMUMLEVEL})
    end
    
    members = Member.all
    
    armoryData.each do |key,value|
      catchTime = Time.now
      dude = @api.get_character key
      attributes = getAttributes dude
      member = members.find {|mem| mem.name == key} || Member.new
      members.delete member if GUILDS.include? member.guild
      member.update_attributes attributes
      member.save
      ##Debug
      puts member.name
      data[:updated].push member.name
      timed = 1.5 - (Time.now - catchTime)
      sleep timed if timed > 0
    end
    data[:removed] = members.map {|mem| mem.name}
    members.each {|mem| mem.destroy}
    data[:timer] = Time.now - timer
    return data
  end

  def caching
    @api.caching
  end
  
  def caching=(swap)
    @api.caching = swap
  end
  
end
