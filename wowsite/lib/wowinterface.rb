class WowInterface
  
  REALM = 'Coilfang'
  GUILDS = ["Alliance Pwners", "Alliance Pwners II"]
  MINIMUMLEVEL = 80
  
  
  def initialize
    @api = Wowr::API.new (:realm => WowInterface::REALM)
  end
  
  def search(name)
    results = @api.search_characters name
    results.select {|dude| dude.realm == WowInterface::REALM}
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
    results = {:added => 0, :removed => 0, :moved => 0}
    armoryData = {}
    #@api.caching = false
    WowInterface::GUILDS.each do |guild|
      @api.guild_name = guild
      g = @api.get_guild
      armoryData.merge!(g.members.reject {|k,v| v.level < WowInterface::MINIMUMLEVEL})
    end
    
    members = Member.all
    
    armoryData.each do |key,value|
      dude = @api.get_character key
      attributes = getAttributes dude
      member = members.find {|mem| mem.name == key} || Member.new
      members.delete member
      member.update_attributes attributes
      member.save
    end
    
    members.each {|mem| mem.destroy}
    
    @api.caching = true
    
  end
  
end
