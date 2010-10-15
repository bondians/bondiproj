class Cull < ActiveRecord::Base
  
  attr_accessor :gone
  
  def gone?
    !FileTest.file?(file)
  end
  
end
