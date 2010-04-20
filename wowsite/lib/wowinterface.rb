class WowInterface
  
  REALM = 'Coilfang'
  
  def initialize
    @api = Wowr::API.new)
  end
  
  def search(name)
    results = @api.search_characters name
    results.select {|dude| dude.realm == WowInterface::REALM}
  end
  
end
