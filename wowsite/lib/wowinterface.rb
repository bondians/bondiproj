class WowInterface < Wowr::API  
  
  REALM = 'Coilfang'
  
  def initialize
    return super
  end
  
  def search(name)
    results = self.search_charachter name
    results.select {|dude| dude.realm == WowInterface::REALM}
  end
  
end
