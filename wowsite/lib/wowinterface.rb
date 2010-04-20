class WowrInterface < Wowr::API  
  
  def initialize
  return super(:character_name => 'Cayuse',
                            :guild_name => "Alliance Pwners II",
                            :realm => 'Coilfang')
  end
  
end
